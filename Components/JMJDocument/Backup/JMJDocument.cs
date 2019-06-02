//
//
//EncounterPRO Open Source Project
//
//Copyright 2010 EncounterPRO Healthcare Resources, Inc.
//
//This program is free software: you can redistribute it and/or modify it under the terms
//of the GNU Affero General Public License as published by  the Free Software Foundation, 
//either version 3 of the License, or (at your option) any later version.
//
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//See the GNU Affero General Public License for more details.
//
//You should have received a copy of the GNU Affero General Public License along with this
//program.  If not, see <http:www.gnu.org/licenses/>.
//
//EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero
//General Public License version 3, or any later version.  As such, linking the Project
//statically or dynamically with other components is making a combined work based on the
//Project. Thus, the terms and conditions of the GNU Affero General Public License 
//version 3, or any later version, cover the whole combination. 
//
//However, as an additional permission, the copyright holders of EncounterPRO Open Source 
//Project give you permission to link the Project with independent components, regardless 
//of the license terms of these independent components, provided that all of the following
//are true:
// 
//1) all access from the independent component to persisted data which resides inside any 
//   EncounterPRO Open Source data store (e.g. SQL Server database) be made through a 
//   publically available database driver (e.g. ODBC, SQL Native Client, etc) or through 
//   a service which itself is part of The Project.
//2) the independent component does not create or rely on any code or data structures 
//   within the EncounterPRO Open Source data store unless such code or data structures, 
//   and all code and data structures referred to by such code or data structures, are 
//   themselves part of The Project.
//3) the independent component either a) runs locally on the user's computer, or b) is 
//   linked to at runtime by The Project’s Component Manager object which in turn is 
//   called by code which itself is part of The Project.
//
//An independent component is a component which is not derived from or based on the
//Project. If you modify the Project, you may extend this additional permission to your
//version of the Project, but you are not obligated to do so. If you do not wish to do
//so, delete this additional permission statement from your version.
//
using System;
using System.Data;
using System.Xml;
using System.Data.SqlClient;
using System.Reflection;

namespace EncounterPRO.OS.Component
{
    /// <summary>
    /// Summary description for Class1.
    /// </summary>
    public class JMJDocument : EncounterPRO.OS.Component.Document
    {
        public JMJDocument()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        XmlDocument objJMJXmlMapperTemplate2;

        protected override string createDocument()
        {
            /************************************************************************************************
             * By Nitin Vikraman								Date: 
             * Modified By Nitin Vikraman						Date: 21-08-2007
            // Generate a JMJDocument XML based on the patient primarycontextobject
            // specified in the clinical context xml. In the clinicalcontext XML,
            // 1. if the primarycontextobject is "patient" then generate the patient demographics
            //	  and all the encounter associated with the patient.
            // 2. if the primarycontextobject is "encounter" then generate the patient demographics
            //	  and the specific encounter details as described in the specs.
            // 3. if the primarycontextobject is "treatment" then generate the patient demographics
            //	  and the specific treatment details as described in the specs.
            // 4. if the primarycontextobject is "assessment" then generate the patient demographics
            //	  and the specific assessment details as described in the specs.
            // 5. if the primarycontextobject is "observation" then generate the patient demographics
            //	  and the specific observation details as described in the specs.
            // 6. if the primarycontextobject is "attachment" then generate the patient demographics
            //	  and the specific attachment details as described in the specs.

            ************************************************************************************************/
            // Validate the ClinicalContext XML
            XmlDocument objClinicalContextXml = new XmlDocument();
            try
            {
                objClinicalContextXml.LoadXml(base.ClinicalContext);

            }
            catch (Exception exc)
            {
                string msg = "Could not load ClinicalContext string into XML Document.";
                throw new Exception(msg, exc);
            }

            try
            {
                string strCprid = "";
                int EncounterId;

                string strPrimaryContextObject = "";
                string TreatmentQuery = "";
                int PrimaryObjectKey = 0;

                DataSet PatientDs = new DataSet();
                DataSet PatientNoteDs = new DataSet();

                DataSet TreatmentDs = new DataSet();



                #region XML Object Declaration

                XmlDeclaration objJMJXmlDec;
                //XmlCDataSection objJMJXmlCDataSection;
                XmlDocument objJMJXmlDoc = null;
                XmlDocument JMJComponentDataDoc = null;

                XmlDocument objMapperTempXmlDoc = null;
                XmlNode objContextObjectXml = null;
                XmlNode objJMJXml = null;
                XmlNode objJMJMapperTempPatient = null;
                XmlNode objJMJXmlActors = null;
                XmlNode objJMJXmlPrimaryContext = null;
                XmlNode objXmlContext = null, objXmlContextKey = null;
                XmlNode objCustomer = null, objOwner = null, objXmlPurpose = null;

                # endregion XML Object Declaration


                #region XML Object Creation

                objJMJXmlDoc = new XmlDocument();
                //objClinicalContextXml=new XmlDocument();
                objMapperTempXmlDoc = new XmlDocument();
                objJMJXmlDec = objJMJXmlDoc.CreateXmlDeclaration("1.0", "UTF-8", null);
                objJMJXmlDoc.InsertBefore(objJMJXmlDec, objJMJXmlDoc.DocumentElement);
                objJMJXml = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "JMJDocument", null);
                objJMJXmlDoc.AppendChild(objJMJXml);



                # endregion XML Object Creation


                #region Read Mapper Template

                System.Reflection.Assembly a = System.Reflection.Assembly.GetExecutingAssembly();
                System.IO.Stream objStream = a.GetManifestResourceStream("EncounterPRO.OS.Component.MapperTemplatev_1_0.xml");
                System.IO.StreamReader StreamRdr = new System.IO.StreamReader(objStream);
                string xmlTemplate = StreamRdr.ReadToEnd();
                objMapperTempXmlDoc.LoadXml(xmlTemplate);
                StreamRdr.Close();

                # endregion Read Mapper Template


                #region Get Primary Clinical Context Object and its key.
                objContextObjectXml = objClinicalContextXml.SelectSingleNode("//EncounterPROContext");
                if (objContextObjectXml == null)
                {
                    string msg = "Could not read ClinicalContext XML Document.";
                    throw new Exception(msg);
                }
                // Get the patient key
                if (objContextObjectXml.Attributes["cpr_id"] != null)
                    strCprid = objContextObjectXml.Attributes["cpr_id"].Value;
                // Get the primary context object
                if (objContextObjectXml.Attributes["PrimaryContextObject"] != null)
                    strPrimaryContextObject = objContextObjectXml.Attributes["PrimaryContextObject"].Value;
                // Get the primary context object key
                if (objContextObjectXml.Attributes["PrimaryObjectKey"] != null)
                    PrimaryObjectKey = Convert.ToInt32(objContextObjectXml.Attributes["PrimaryObjectKey"].Value);
                # endregion
                // Updated by Sumathi 10/12/2007: Since JMJDocument introduced a node "PrimaryContext" All these will be
                // mapped in there.
                /*				XmlAttribute objJMJAttrib=objJMJXmlDoc.CreateAttribute("PrimaryContext");
                                objJMJAttrib.Value=strPrimaryContextObject;
                                objJMJXml.Attributes.Append(objJMJAttrib);
                                objJMJAttrib=objJMJXmlDoc.CreateAttribute("Description");
                                objJMJAttrib.Value="JMJ-EncounterPRO Patient data";
                                objJMJXml.Attributes.Append(objJMJAttrib);*/
                objJMJXmlPrimaryContext = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "PrimaryContext", null);
                objXmlContext = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "ContextObject", null);
                objXmlContext.InnerText = strPrimaryContextObject;
                if (strPrimaryContextObject.ToLower() == "treatment")
                {
                    objXmlContextKey = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "TreatmentID", null);
                    objXmlContextKey.InnerText = PrimaryObjectKey.ToString();
                }
                if (strPrimaryContextObject.ToLower() == "encounter")
                {
                    objXmlContextKey = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "EncounterID", null);
                    objXmlContextKey.InnerText = PrimaryObjectKey.ToString();
                }
                if (strPrimaryContextObject.ToLower() == "assessment")
                {
                    objXmlContextKey = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "AssessmentID", null);
                    objXmlContextKey.InnerText = PrimaryObjectKey.ToString();
                }
                if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//Purpose") != null)
                    if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//Purpose").InnerText != null)
                    {
                        objXmlPurpose = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "Purpose", null);
                        objXmlPurpose.InnerText = JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//Purpose").InnerText;
                        objJMJXmlPrimaryContext.AppendChild(objXmlPurpose);
                    }
                objJMJXmlPrimaryContext.AppendChild(objXmlContext);
                objJMJXmlPrimaryContext.AppendChild(objXmlContextKey);
                objJMJXml.AppendChild(objJMJXmlPrimaryContext);

                // Now insert the CustomerID and OwnerID
                if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//SystemSettings//ScreenSettings//CustomerID") != null)
                {
                    objCustomer = objJMJMapperTempPatient.SelectSingleNode("//JMJDocument//CustomerID");
                    objCustomer.InnerText = JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//SystemSettings//ScreenSettings//CustomerID").InnerText;
                    objJMJXml.AppendChild(objCustomer);
                    objOwner = objJMJMapperTempPatient.SelectSingleNode("//JMJDocument//OwnerID");
                    objOwner.InnerText = JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//SystemSettings//ScreenSettings//CustomerID").InnerText;
                    objJMJXml.AppendChild(objOwner);
                }
                // Now insert the creator block


                # region Fill in the Patient Demographics

                //				// Retrieve the patient demographics
                System.Data.SqlClient.SqlParameter[] PatientDsParams = new System.Data.SqlClient.SqlParameter[1];
                PatientDsParams[0] = new SqlParameter("@ps_cpr_id", SqlDbType.VarChar);
                PatientDsParams[0].Value = strCprid;
                PatientDs = base.ExecuteSql("exec dbo.jmjdoc_get_patient @ps_cpr_id", ref PatientDsParams);
                if (PatientDs.Tables[0].Rows.Count == 0)
                {
                    throw new Exception("No Patient Records");

                }


                //Retrieve the patientNotes (only the progress data at this time ie attachment flag = 'N')
                PatientNoteDs = this.getProgress(strCprid, "Patient", 0, null, null, null);

                objJMJMapperTempPatient = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord");
                CreatePatient(objJMJXmlDoc, objJMJXml, objJMJMapperTempPatient, PatientDs, PatientNoteDs);

                # endregion fill in the patient demographics

                # region Primary Context is "Patient
                if (strPrimaryContextObject.ToLower() == "patient")
                {
                    objJMJXmlActors = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "Actors", null);
                    objJMJXml.AppendChild(objJMJXmlActors);
                    ProcessPatientEncounterContext(strCprid, objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlActors, objMapperTempXmlDoc);
                    TreatmentQuery = "exec dbo.jmjdoc_get_treatment @ps_cpr_id,@ps_context_object,@pl_object_key";
                    ProcessTreatmentContext(TreatmentQuery, PrimaryObjectKey, strCprid, "Encounter", 0, 0, objJMJXmlDoc,
                        JMJComponentDataDoc, objJMJXmlActors, objMapperTempXmlDoc);

                }
                # endregion Clinical Context=="Patient

                # region  Primary Context is "Encounter"
                if (strPrimaryContextObject.ToLower() == "encounter")
                {
                    EncounterId = PrimaryObjectKey;
                    objJMJXmlActors = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "Actors", null);
                    objJMJXml.AppendChild(objJMJXmlActors);
                    ProcessEncounterClinicalContext(EncounterId, strCprid, objJMJXmlDoc, JMJComponentDataDoc,
                        objJMJXmlActors, objMapperTempXmlDoc);

                }

                # endregion  Clinical Context=="Encounter"

                # region Primary Clinical Context=="Assessment"
                //objContextObjectXml = objClinicalContextXml.SelectSingleNode("//EncounterPROContext/ContextObject[@ContextObject='Assessment']");
                if (strPrimaryContextObject.ToLower() == "assessment")
                {
                    objJMJXmlActors = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "Actors", null);
                    objJMJXml.AppendChild(objJMJXmlActors);
                    ProcessAssessmentClinicalContext(PrimaryObjectKey, strCprid, objJMJXmlDoc,
                        JMJComponentDataDoc, objJMJXmlActors, objMapperTempXmlDoc);

                }
                # endregion  Clinical Context=="Assessment"


                # region Primary Clinical Context=="Treatment"

                if (strPrimaryContextObject.ToLower() == "treatment")
                {
                    objJMJXmlActors = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "Actors", null);
                    objJMJXml.AppendChild(objJMJXmlActors);
                    ProcessTreatmentClinicalContextAssessment(PrimaryObjectKey, strCprid, objJMJXmlDoc, JMJComponentDataDoc,
                        objJMJXmlActors, objMapperTempXmlDoc);
                }
                # endregion Clinical Context=="Treatment"

                return objJMJXmlDoc.OuterXml;
            }
            catch (Exception ex)
            {
                string msg = "Error while creation of JMJDocument.";
                throw new Exception(msg, ex);
            }
        }
        protected override string getDocumentElements(string test)
        {
            return "";
        }
        protected override string configureDocument(string test)
        {
            return "";
        }
        protected override string createDocument(string JMJComponentData)
        {
            /************************************************************************************************
             * By Nitin Vikraman							Date: 21-08-2007
            // Generate a JMJDocument XML based on the patient primarycontextobject
            // specified in the clinical context xml. In the clinicalcontext XML,
            // 1. if the primarycontextobject is "patient" then generate the patient demographics
            //	  and all the encounter associated with the patient.
            // 2. if the primarycontextobject is "encounter" then generate the patient demographics
            //	  and the specific encounter details as described in the specs.
            // 3. if the primarycontextobject is "treatment" then generate the patient demographics
            //	  and the specific treatment details as described in the specs.
            // 4. if the primarycontextobject is "assessment" then generate the patient demographics
            //	  and the specific assessment details as described in the specs.
            // 5. if the primarycontextobject is "observation" then generate the patient demographics
            //	  and the specific observation details as described in the specs.
            // 6. if the primarycontextobject is "attachment" then generate the patient demographics
            //	  and the specific attachment details as described in the specs.

            ************************************************************************************************/
            // Validate the ClinicalContext XML
            XmlDocument objClinicalContextXml = new XmlDocument();
            try
            {
                objClinicalContextXml.LoadXml(base.ClinicalContext);

            }
            catch (Exception exc)
            {
                string msg = "Could not load ClinicalContext string into XML Document.";
                throw new Exception(msg, exc);
            }

            try
            {
                string strCprid = "";
                string strAppVer = "5.0.2x";
                string strCompVer = "0.0.0.0";
                int EncounterId;

                string strPrimaryContextObject = "";
                string TreatmentQuery = "";
                int PrimaryObjectKey = 0;

                DataSet PatientDs = new DataSet();
                DataSet PatientNoteDs = new DataSet();

                DataSet TreatmentDs = new DataSet();

                strCompVer = Assembly.GetExecutingAssembly().GetName().Version.ToString();


                #region XML Object Declaration

                XmlDeclaration objJMJXmlDec;
                //XmlCDataSection objJMJXmlCDataSection;
                XmlDocument objJMJXmlDoc = null;
                XmlDocument JMJComponentDataDoc = null;
                XmlDocument objMapperTempXmlDoc = null;
                XmlNode objContextObjectXml = null;
                XmlNode objJMJXml = null;
                XmlNode objJMJMapperTempPatient = null;
                XmlNode objJMJXmlActors = null;
                XmlNode objJMJXmlPrimaryContext = null;
                XmlNode objXmlContext = null, objXmlContextKey = null, objXmlPurpose = null;
                XmlNode objCustomer = null, objOwner = null;
                XmlNode objPrimaryContextMessage = null;
                XmlNode objCreator = null, objAppName = null, objAppVersion = null, objCreateDt = null, objComp = null, objCompVersion = null, objVenName = null;

                # endregion XML Object Declaration


                #region XML Object Creation

                objJMJXmlDoc = new XmlDocument();
                //objClinicalContextXml=new XmlDocument();
                objMapperTempXmlDoc = new XmlDocument();
                JMJComponentDataDoc = new XmlDocument();
                objJMJXmlDec = objJMJXmlDoc.CreateXmlDeclaration("1.0", "UTF-8", null);
                objJMJXmlDoc.InsertBefore(objJMJXmlDec, objJMJXmlDoc.DocumentElement);
                objJMJXml = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "JMJDocument", null);
                objJMJXmlDoc.AppendChild(objJMJXml);

                objJMJXmlActors = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "Actors", null);
                objJMJXml.AppendChild(objJMJXmlActors);



                # endregion XML Object Creation

                #region Read Mapper Template


                System.Reflection.Assembly a = System.Reflection.Assembly.GetExecutingAssembly();
                string[] ResourceNames = a.GetManifestResourceNames();
                System.IO.Stream objStream = a.GetManifestResourceStream("EncounterPRO.OS.Component.MapperTemplatev_1_2.xml");
                System.IO.StreamReader StreamRdr = new System.IO.StreamReader(objStream);
                string xmlTemplate = StreamRdr.ReadToEnd();
                objMapperTempXmlDoc.LoadXml(xmlTemplate);
                StreamRdr.Close();

                // assign the mappertemplate to instance variable which is used in check/create the last encounter block in treatment.order
                objJMJXmlMapperTemplate2 = objMapperTempXmlDoc;
                # endregion Read Mapper Template


                #region Get Primary Clinical Context Object and its key.
                JMJComponentDataDoc.LoadXml(JMJComponentData);
                objContextObjectXml = objClinicalContextXml.SelectSingleNode("//EncounterPROContext");
                if (objContextObjectXml == null)
                {
                    string msg = "Could not read ClinicalContext XML Document.";
                    throw new Exception(msg);
                }
                // Get the patient key
                if (objContextObjectXml.Attributes["cpr_id"] != null)
                {
                    strCprid = objContextObjectXml.Attributes["cpr_id"].Value;
                }
                if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//ContextObject") != null &&
                    JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//ObjectKey") != null)
                {
                    if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//ContextObject").InnerText != "" &&
                        JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//ObjectKey").InnerText != "")
                    {
                        strPrimaryContextObject = JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//ContextObject").InnerText;
                        PrimaryObjectKey = Convert.ToInt32(JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//ObjectKey").InnerText);
                    }
                    else
                    {
                        // Get the primary context object
                        if (objContextObjectXml.Attributes["PrimaryContextObject"] != null)
                            strPrimaryContextObject = objContextObjectXml.Attributes["PrimaryContextObject"].Value;
                        // Get the primary context object key
                        if (objContextObjectXml.Attributes["PrimaryObjectKey"] != null)
                            PrimaryObjectKey = Convert.ToInt32(objContextObjectXml.Attributes["PrimaryObjectKey"].Value);
                    }
                }
                else
                {
                    // Get the primary context object
                    if (objContextObjectXml.Attributes["PrimaryContextObject"] != null)
                        strPrimaryContextObject = objContextObjectXml.Attributes["PrimaryContextObject"].Value;
                    // Get the primary context object key
                    if (objContextObjectXml.Attributes["PrimaryObjectKey"] != null)
                        PrimaryObjectKey = Convert.ToInt32(objContextObjectXml.Attributes["PrimaryObjectKey"].Value);
                }
                # endregion
                // Updated by Sumathi 10/12/2007: Since JMJDocument introduced a node "PrimaryContext" All these will be
                // mapped in there.
                /*				XmlAttribute objJMJAttrib=objJMJXmlDoc.CreateAttribute("PrimaryContext");
                                objJMJAttrib.Value=strPrimaryContextObject;
                                objJMJXml.Attributes.Append(objJMJAttrib);
                                objJMJAttrib=objJMJXmlDoc.CreateAttribute("Description");
                                objJMJAttrib.Value="JMJ-EncounterPRO Patient data";
                                objJMJXml.Attributes.Append(objJMJAttrib);*/
                objJMJXmlPrimaryContext = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "PrimaryContext", null);
                objXmlContext = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "ContextObject", null);
                objXmlContext.InnerText = strPrimaryContextObject;
                if (strPrimaryContextObject.ToLower() == "treatment")
                {
                    objXmlContextKey = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "TreatmentID", null);
                    objXmlContextKey.InnerText = PrimaryObjectKey.ToString();
                }
                if (strPrimaryContextObject.ToLower() == "encounter")
                {
                    objXmlContextKey = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "EncounterID", null);
                    objXmlContextKey.InnerText = PrimaryObjectKey.ToString();
                }
                if (strPrimaryContextObject.ToLower() == "assessment")
                {
                    objXmlContextKey = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "AssessmentID", null);
                    objXmlContextKey.InnerText = PrimaryObjectKey.ToString();
                }
                if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//Purpose") != null)
                    if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//Purpose").InnerText != null)
                    {
                        objXmlPurpose = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "Purpose", null);
                        objXmlPurpose.InnerText = JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//Purpose").InnerText;
                        objJMJXmlPrimaryContext.AppendChild(objXmlPurpose);
                    }
                objJMJXmlPrimaryContext.AppendChild(objXmlContext);
                objJMJXmlPrimaryContext.AppendChild(objXmlContextKey);

                // Insert the Context specific Message under primary context
                objPrimaryContextMessage = CreatePrimaryContextMessage(JMJComponentDataDoc, objJMJXmlActors, objJMJXmlDoc);
                if (objPrimaryContextMessage != null)
                    objJMJXmlPrimaryContext.AppendChild(objPrimaryContextMessage);
                objJMJXml.AppendChild(objJMJXmlPrimaryContext);

                // Now insert the CustomerID and OwnerID
                if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//SystemSettings//CustomerID") != null)
                {
                    objCustomer = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "CustomerID", null);
                    objCustomer.InnerText = JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//SystemSettings//CustomerID").InnerText;
                    objJMJXml.AppendChild(objCustomer);
                    objOwner = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "OwnerID", null);
                    objOwner.InnerText = JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//SystemSettings//CustomerID").InnerText;
                    objJMJXml.AppendChild(objOwner);
                }

                // Now insert the creator block and fill in appversion and vendorname extra details
                objCreator = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "Creator", null);
                objCreateDt = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "CreateDate", null);
                objCreateDt.InnerText = System.DateTime.Today.ToString();
                objCreator.AppendChild(objCreateDt);
                objVenName = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "VendorName", null);
                objVenName.InnerText = "EncounterPRO Healthcare Resources";
                objCreator.AppendChild(objVenName);
                objAppName = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "ApplicationName", null);
                objAppName.InnerText = "EncounterPRO";
                objCreator.AppendChild(objAppName);
                objAppVersion = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "ApplicationVersion", null);
                if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//SystemSettings//CallerVersion") != null && JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//SystemSettings//CallerVersion").InnerText != null)
                    objAppVersion.InnerText = JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//SystemSettings//CallerVersion").InnerText;
                else
                    objAppVersion.InnerText = strAppVer.ToString();
                objCreator.AppendChild(objAppVersion);
                objComp = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "ComponentName", null);
                objComp.InnerText = "JMJDocument";
                objCreator.AppendChild(objComp);
                objCompVersion = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "ComponentVersion", null);
                objCompVersion.InnerText = strCompVer.ToString();
                objCreator.AppendChild(objCompVersion);
                objJMJXml.AppendChild(objCreator);


                # region Fill in the Patient Demographics

                //				// Retrieve the patient demographics
                System.Data.SqlClient.SqlParameter[] PatientDsParams = new System.Data.SqlClient.SqlParameter[1];
                PatientDsParams[0] = new SqlParameter("@ps_cpr_id", SqlDbType.VarChar);
                PatientDsParams[0].Value = strCprid;
                PatientDs = base.ExecuteSql("exec dbo.jmjdoc_get_patient @ps_cpr_id", ref PatientDsParams);
                if (PatientDs.Tables[0].Rows.Count == 0)
                {
                    throw new Exception("No Patient Records");

                }


                //Retrieve the patientNotes (only the progress data at this time ie attachment flag = 'N')
                PatientNoteDs = this.getProgress(strCprid, "Patient", 0, null, null, null);

                objJMJMapperTempPatient = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord");
                CreatePatient(objJMJXmlDoc, objJMJXml, objJMJMapperTempPatient, PatientDs, PatientNoteDs);

                # endregion fill in the patient demographics

                # region Primary Context is "Patient
                if (strPrimaryContextObject.ToLower() == "patient")
                {
                    ProcessPatientEncounterContext(strCprid, objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlActors, objMapperTempXmlDoc);
                    TreatmentQuery = "exec dbo.jmjdoc_get_treatment @ps_cpr_id,@ps_context_object,@pl_object_key";
                    ProcessTreatmentContext(TreatmentQuery, PrimaryObjectKey, strCprid, "Encounter", 0, 0, objJMJXmlDoc,
                        JMJComponentDataDoc, objJMJXmlActors, objMapperTempXmlDoc);

                }
                # endregion Clinical Context=="Patient

                # region  Primary Context is "Encounter"
                if (strPrimaryContextObject.ToLower() == "encounter")
                {
                    EncounterId = PrimaryObjectKey;
                    ProcessEncounterClinicalContext(EncounterId, strCprid, objJMJXmlDoc, JMJComponentDataDoc,
                        objJMJXmlActors, objMapperTempXmlDoc);

                }

                # endregion  Clinical Context=="Encounter"

                # region Primary Clinical Context=="Assessment"
                //objContextObjectXml = objClinicalContextXml.SelectSingleNode("//EncounterPROContext/ContextObject[@ContextObject='Assessment']");
                if (strPrimaryContextObject.ToLower() == "assessment")
                {
                    ProcessAssessmentClinicalContext(PrimaryObjectKey, strCprid, objJMJXmlDoc, JMJComponentDataDoc,
                        objJMJXmlActors, objMapperTempXmlDoc);

                }
                # endregion  Clinical Context=="Assessment"


                # region Primary Clinical Context=="Treatment"

                if (strPrimaryContextObject.ToLower() == "treatment")
                {
                    ProcessTreatmentClinicalContextAssessment(PrimaryObjectKey, strCprid, objJMJXmlDoc,
                        JMJComponentDataDoc, objJMJXmlActors, objMapperTempXmlDoc);
                }
                # endregion Clinical Context=="Treatment"

                return objJMJXmlDoc.OuterXml;
            }
            catch (Exception ex)
            {
                string msg = "Error while creation of JMJDocument.";
                throw new Exception(msg, ex);
            }
        }


        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * Modified By: Nitin Vikraman		  Date: 21-08-2007
        * 
        * Purpose: This function is called for the creation of Assessment
        * Nodes associated with Encounter
        * 
        * Description: 
        * This routine returns Assessment Nodes associated with the encounter
        * when clinical context is Encounter
        *
        * ******************************************************************/

        private void ProcessEncounterClinicalAssessmentContext(int objectKey, string strCprid,
            XmlDocument objJMJXmlDoc, XmlDocument JMJComponentDataDoc, XmlNode objJMJXmlActors,
            XmlDocument objMapperTempXmlDoc)
        {
            // This Function has been tested
            // This function is used by Patient and Encounter Context
            DataSet AssessmentDs = new DataSet();
            DataSet EncounterDs = new DataSet();
            DataSet AssessmentNoteDs = new DataSet();
            DataSet EncounterNoteDs = new DataSet();
            XmlDocument objTreatmentDoc = new XmlDocument();
            XmlNodeList EncounterJMJValueNodeList = null;
            XmlNodeList objJMJMapperTempActorList = null;
            XmlNodeList AssessmentJMJValueNodeList = null;
            DataRow AssessmentDr = null;
            DataRow EncounterDr = null;
            XmlNode objJMJMapperTempAssessment = null;
            int AssessmentProblemId = 0;
            int OpenEncounter = 0;
            int CloseEncounter = 0;
            try
            {
                AssessmentDs = GetAssessment(strCprid, "Encounter", objectKey);
                if (AssessmentDs != null)
                {
                    if (AssessmentDs.Tables.Count > 0)
                    {
                        if (AssessmentDs.Tables[0].Rows.Count > 0)
                        {

                            objJMJMapperTempAssessment = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Assessment");
                            objJMJMapperTempActorList = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Actors").ChildNodes;
                            for (int iAssessmentRowCounter = 0; iAssessmentRowCounter < AssessmentDs.Tables[0].Rows.Count; iAssessmentRowCounter++)
                            {
                                // Section for adding conditions on Creation of encounter assessments
                                AssessmentDr = AssessmentDs.Tables[0].Rows[iAssessmentRowCounter];

                                if (!IsDataRowNull(AssessmentDr, "problemid"))
                                {
                                    if (AssessmentDr["problemid"] != System.DBNull.Value)
                                    {
                                        AssessmentProblemId = Convert.ToInt32(AssessmentDr["problemid"].ToString());
                                        AssessmentNoteDs = getProgress(strCprid, "Assessment", AssessmentProblemId, null, null, null);
                                    }
                                }
                                if (!IsDataRowNull(AssessmentDr, "openencounter"))
                                {
                                    if (AssessmentDr["openencounter"] != System.DBNull.Value)
                                    {
                                        OpenEncounter = Convert.ToInt32(AssessmentDr["openencounter"].ToString());
                                        // Check if the Encounter exist with Encounter.encounterid=OpenEncounter

                                        EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                                        bool ContainsEncounter = false;
                                        for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                                        {
                                            if (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) == OpenEncounter)
                                            {
                                                ContainsEncounter = true;
                                                // Modify the Encounter node
                                                EncounterDs = GetEncounter(strCprid, OpenEncounter);
                                                if (EncounterDs != null)
                                                {
                                                    if (EncounterDs.Tables.Count > 0)
                                                    {
                                                        if (EncounterDs.Tables[0].Rows.Count > 0)
                                                        {
                                                            EncounterDr = EncounterDs.Tables[0].Rows[0];
                                                            EncounterNoteDs = this.getProgress(strCprid, "Encounter", OpenEncounter, null, null, null);
                                                            XmlNode JMJEncounterNode = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter];
                                                            if (Convert.ToInt32(JMJEncounterNode.Attributes["EncounterID"].Value) == Convert.ToInt32(EncounterDr["encounterid"].ToString()))
                                                            {
                                                                UpdateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter],
                                                                    objJMJXmlActors, objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Encounter"),
                                                                    objJMJMapperTempActorList, EncounterDr, EncounterNoteDs);
                                                                break;
                                                            }
                                                        }
                                                    }
                                                }


                                            }
                                            else if (ContainsEncounter == false && ((iCounter + 1) == EncounterJMJValueNodeList.Count)
                                                && (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) != OpenEncounter))
                                            {
                                                ProcessEncounterContext(OpenEncounter, strCprid, objJMJXmlDoc, objJMJXmlActors, objMapperTempXmlDoc);
                                            }
                                        }

                                    }
                                }
                                if (!IsDataRowNull(AssessmentDr, "closeencounter"))
                                {
                                    if (AssessmentDr["closeencounter"] != System.DBNull.Value)
                                    {
                                        CloseEncounter = Convert.ToInt32(AssessmentDr["closeencounter"].ToString());
                                        // Check if the Encounter exist with Encounter.encounterid=OpenEncounter
                                        EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                                        bool ContainsEncounter = false;
                                        for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                                        {
                                            if (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) == CloseEncounter)
                                            {
                                                ContainsEncounter = true;
                                                break;
                                            }
                                            else if (ContainsEncounter == false && ((iCounter + 1) == EncounterJMJValueNodeList.Count)
                                                && (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) != CloseEncounter))
                                            {
                                                ProcessEncounterContext(CloseEncounter, strCprid, objJMJXmlDoc, objJMJXmlActors, objMapperTempXmlDoc);
                                            }
                                        }

                                    }
                                }
                                // Create Assessment Node
                                bool ContainsAssessment = false;
                                AssessmentJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Assessment/ObjectID/JMJValue");
                                for (int iCounter = 0; iCounter < AssessmentJMJValueNodeList.Count; iCounter++)
                                {

                                    if (AssessmentProblemId == Convert.ToInt32(AssessmentJMJValueNodeList[iCounter].InnerText))
                                    {
                                        ContainsAssessment = true;
                                    }
                                }
                                if (!ContainsAssessment)
                                {
                                    CreateAssessment(objJMJXmlDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                                        objJMJXmlActors, objJMJMapperTempAssessment, objJMJMapperTempActorList,
                                        AssessmentDr, AssessmentNoteDs);

                                }
                                if (!IsDataRowNull(AssessmentDr, "problemid") &&
                                    !IsDataRowNull(AssessmentDr, "openencounter"))
                                {
                                    if (AssessmentDr["problemid"] != System.DBNull.Value &&
                                        AssessmentDr["openencounter"] != System.DBNull.Value)
                                    {
                                        if (Convert.ToInt32(AssessmentDr["openencounter"].ToString()) == objectKey)
                                        {
                                            AssessmentProblemId = Convert.ToInt32(AssessmentDr["problemid"].ToString());
                                            ProcessEncounterClincalContextEncDxTreatment(strCprid, objectKey,
                                                AssessmentProblemId, objJMJXmlDoc, JMJComponentDataDoc,
                                                objJMJXmlActors, objMapperTempXmlDoc);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                string msg = "Error while creating Assessment Nodes. Updated Error messages";
                throw new Exception(msg + ex.StackTrace, ex);
            }


        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of Encouner,
        * Assessment,Treatment Nodes when Clincal Context is Encounter
        * 
        * Description: 
        * This routine returns Encounter Node and  associated assessment nodes
        * along with the Treatment Nodes.
        *
        * ******************************************************************/

        private void ProcessEncounterClinicalContext(int EncounterId, string strCprid, XmlDocument objJMJXmlDoc,
            XmlDocument JMJComponentDataDoc, XmlNode objJMJXmlActors, XmlDocument objMapperTempXmlDoc)
        {
            DataSet EncounterDs = new DataSet();
            DataSet ChargeDs = new DataSet();
            DataSet EncounterNoteDs = new DataSet();

            DataRow EncounterDr = null;
            XmlNode objJMJMapperTempEncounter = null;
            XmlNodeList objJMJMapperTempActorList = null;

            try
            {
                EncounterDs = GetEncounter(strCprid, EncounterId);
                if (EncounterDs.Tables[0].Rows.Count > 0)
                {

                    EncounterNoteDs = this.getProgress(strCprid, "Encounter", EncounterId, null, null, null);
                    objJMJMapperTempActorList = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Actors").ChildNodes;
                    objJMJMapperTempEncounter = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Encounter");
                    EncounterDr = EncounterDs.Tables[0].Rows[0];
                    CreateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                        objJMJXmlActors, objJMJMapperTempEncounter, objJMJMapperTempActorList, EncounterDr, EncounterNoteDs, true);
                    ProcessEncounterClinicalAssessmentContext(EncounterId, strCprid, objJMJXmlDoc, JMJComponentDataDoc,
                        objJMJXmlActors, objMapperTempXmlDoc);
                    ProcessEncounterClincalContextTreatment(strCprid, "Encounter", EncounterId,
                        objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlActors, objMapperTempXmlDoc);
                    // Add code to create charges node

                    // Get Charges info by executing the stored proceedures
                    ChargeDs = GetCharges(strCprid, Convert.ToInt32(EncounterDr["encounterid"].ToString()));


                    XmlNode EncounterCharge = objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord/Encounter[ObjectID/JMJValue='" +
                        EncounterDr["encounterid"] + "']");
                    for (int ChgCounter = 0; ChgCounter < ChargeDs.Tables[0].Rows.Count; ChgCounter++)
                    {
                        CreateCharges(objJMJXmlDoc, EncounterCharge, objMapperTempXmlDoc.SelectSingleNode("//JMJDocument//Charge"),
                            ChargeDs.Tables[0].Rows[ChgCounter], null);

                    }
                }
            }

            catch (Exception ex)
            {
                string msg = "Error While creation of Encounter Clinical Context.";
                throw new Exception(msg, ex);
            }

        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 14-12-2007
        * 
        * Purpose: This function is called for the creation of Charge Nodes 
        * and child node
        * 
        * Description: 
        * 
        * ******************************************************************/

        private void CreateCharges(XmlDocument objJMJXmlDoc, XmlNode objEncounterNode,
            XmlNode objJMJMapperCharge, DataRow ChargeDr, DataRow icd9Dr)
        {
            try
            {
                XmlNode objJMJXmlCharge = null;
                DataSet icd9codeDs = new DataSet();
                objJMJXmlCharge = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objJMJMapperCharge.Name, null);
                objEncounterNode.AppendChild(objJMJXmlCharge);


                if (objJMJMapperCharge.ChildNodes.Count > 0 &&
                    objJMJMapperCharge.NodeType == XmlNodeType.Element)
                {
                    // Create Attributes
                    if (objJMJMapperCharge.Attributes.Count > 0)
                    {
                        if (objJMJMapperCharge.Attributes["default"] != null)
                        {
                            if (objJMJMapperCharge.Attributes["default"].Value != "")
                            {
                                objJMJXmlCharge.InnerText = objJMJMapperCharge.
                                    Attributes["default"].Value;

                            }
                        }
                        // Find the related treatment block with charge and map the treatment id
                        if (objJMJMapperCharge.Attributes["TreatmentID"] != null &&
                            objJMJMapperCharge.Name == "Treatment")
                        {
                            if (objJMJMapperCharge.Attributes["TreatmentID"].Value != "")
                            {
                                if (!IsDataRowNull(ChargeDr, "treatmentid"))
                                {
                                    int TreatmentID = Convert.ToInt32(ChargeDr["treatmentid"].ToString());
                                    if (!IsNodeNull(objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord/Treatment[ObjectID/JMJDomain='treatment_id' and ObjectID/JMJValue='" +
                                        TreatmentID + "']")))
                                    {
                                        XmlNode TreatmentNode = objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord/Treatment[ObjectID/JMJDomain='treatment_id' and ObjectID/JMJValue='" +
                                            TreatmentID + "']");
                                        objJMJXmlCharge.InnerText = TreatmentNode.Attributes["TreatmentID"].InnerText;

                                    }
                                }
                                else
                                {
                                    objEncounterNode.RemoveChild(objJMJXmlCharge);
                                }

                            }
                        }
                        // Find the related Assessment block with charge and map the assessment id
                        if (objJMJMapperCharge.Attributes["AssessmentID"] != null &&
                            objJMJMapperCharge.Name == "Assessment")
                        {
                            if (objJMJMapperCharge.Attributes["AssessmentID"].Value != "")
                            {
                                if (!IsDataRowNull(icd9Dr, "problemid"))
                                {
                                    int AssessmentID = Convert.ToInt32(icd9Dr["problemid"].ToString());
                                    if (!IsNodeNull(objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord/Assessment[ObjectID/JMJDomain='problem_id' and ObjectID/JMJValue='" +
                                        AssessmentID + "']")))
                                    {
                                        XmlNode AssessmentNode = objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord/Assessment[ObjectID/JMJDomain='problem_id' and ObjectID/JMJValue='" +
                                            AssessmentID + "']");
                                        objJMJXmlCharge.InnerText = AssessmentNode.Attributes["AssessmentID"].InnerText;

                                    }
                                }

                            }
                        }

                    }
                    else if (objJMJMapperCharge.InnerText == "" && !objJMJMapperCharge.HasChildNodes)
                    {
                        objEncounterNode.RemoveChild(objJMJXmlCharge);
                    }

                    foreach (XmlNode MapperChargeChild in objJMJMapperCharge.ChildNodes)
                    {
                        if (MapperChargeChild.NodeType == XmlNodeType.Element)
                        {
                            if (MapperChargeChild.Name == "Assessment" &&
                                MapperChargeChild.SelectSingleNode("Assessment") != null)
                            {
                                // get icd9code info and create the assessment block within the charge node
                                icd9codeDs = Geticd9code(ChargeDr["cprid"].ToString(),
                                    Convert.ToInt32(ChargeDr["encounterid"].ToString()), Convert.ToInt32(ChargeDr["chargeid"].ToString()));
                                for (int icd9Counter = 0; icd9Counter < icd9codeDs.Tables[0].Rows.Count; icd9Counter++)
                                {
                                    CreateCharges(objJMJXmlDoc, objJMJXmlCharge, MapperChargeChild,
                                        ChargeDr, icd9codeDs.Tables[0].Rows[icd9Counter]);
                                }

                            }
                            else
                            {
                                CreateCharges(objJMJXmlDoc, objJMJXmlCharge, MapperChargeChild, ChargeDr, icd9Dr);
                            }
                        }
                        else if (MapperChargeChild.NodeType == XmlNodeType.Text
                            && MapperChargeChild.Name == "#text")
                        {
                            if (objJMJXmlCharge.Name == "ICD9Code" && !IsDataRowNull(icd9Dr, MapperChargeChild.InnerText))
                            {
                                objJMJXmlCharge.InnerText = icd9Dr[MapperChargeChild.InnerText].ToString();
                            }

                            if (!IsDataRowNull(ChargeDr, MapperChargeChild.InnerText))
                            {
                                // Condition to check Check for null values in the datarow
                                // If condition true , then set the node text
                                if (ChargeDr[MapperChargeChild.InnerText] != System.DBNull.Value)
                                {

                                    {
                                        objJMJXmlCharge.InnerText = ChargeDr[MapperChargeChild.InnerText].ToString();
                                    }
                                }
                                // If the condition false, then remove the node
                                else
                                {
                                    objEncounterNode.RemoveChild(objJMJXmlCharge);
                                }
                            }
                            else
                            {
                                objEncounterNode.RemoveChild(objJMJXmlCharge);
                            }


                        }
                    }
                    if (objJMJXmlCharge.InnerText == "" && objJMJXmlCharge.Attributes.Count == 0 && objEncounterNode.SelectSingleNode(objJMJMapperCharge.Name) != null)
                    {
                        objEncounterNode.RemoveChild(objJMJXmlCharge);
                    }

                }
                else if (objJMJMapperCharge.NodeType == XmlNodeType.Element)
                {
                    // Create Attributes
                    if (objJMJMapperCharge.Attributes.Count > 0)
                    {
                        if (objJMJMapperCharge.Attributes["default"] != null)
                        {
                            if (objJMJMapperCharge.Attributes["default"].Value != "")
                            {
                                objJMJXmlCharge.InnerText = objJMJMapperCharge.
                                    Attributes["default"].Value;

                            }
                        }
                        // Find the related treatment block with charge and map the treatment id
                        if (objJMJMapperCharge.Attributes["TreatmentID"] != null &&
                            objJMJMapperCharge.Name == "Treatment")
                        {
                            if (objJMJMapperCharge.Attributes["TreatmentID"].Value != "")
                            {
                                if (!IsDataRowNull(ChargeDr, "treatmentid"))
                                {
                                    int TreatmentID = Convert.ToInt32(ChargeDr["treatmentid"].ToString());
                                    if (!IsNodeNull(objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord/Treatment[ObjectID/JMJDomain='treatment_id' and ObjectID/JMJValue='" +
                                        TreatmentID + "']")))
                                    {
                                        XmlNode TreatmentNode = objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord/Treatment[ObjectID/JMJDomain='treatment_id' and ObjectID/JMJValue='" +
                                            TreatmentID + "']");
                                        objJMJXmlCharge.InnerText = TreatmentNode.Attributes["TreatmentID"].InnerText;

                                    }
                                }
                                else
                                {
                                    objEncounterNode.RemoveChild(objJMJXmlCharge);
                                }

                            }
                        }
                        // Find the related Assessment block with charge and map the assessment id
                        if (objJMJMapperCharge.Attributes["AssessmentID"] != null &&
                            objJMJMapperCharge.Name == "Assessment")
                        {

                            if (!IsDataRowNull(icd9Dr, "problemid"))
                            {
                                int AssessmentID = Convert.ToInt32(icd9Dr["problemid"].ToString());
                                if (!IsNodeNull(objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord/Assessment[ObjectID/JMJDomain='problem_id' and ObjectID/JMJValue='" +
                                    AssessmentID + "']")))
                                {
                                    XmlNode AssessmentNode = objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord/Assessment[ObjectID/JMJDomain='problem_id' and ObjectID/JMJValue='" +
                                        AssessmentID + "']");
                                    objJMJXmlCharge.InnerText = AssessmentNode.Attributes["AssessmentID"].InnerText;

                                }
                            }

                        }
                    }
                    else if (objJMJMapperCharge.InnerText == "" && !objJMJMapperCharge.HasChildNodes && objEncounterNode.SelectSingleNode(objJMJMapperCharge.Name) != null)
                    {
                        objEncounterNode.RemoveChild(objJMJXmlCharge);
                    }

                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error while creation of Charge Nodes", ex);
            }

        }

        private bool TreatmentContiansEncounter(DataSet TreatmentDs)
        {
            bool ContainsEncounter = false;
            DataRow TreatmentDr;
            for (int iTreatmentRowCounter = 0; iTreatmentRowCounter < TreatmentDs.Tables[0].Rows.Count; iTreatmentRowCounter++)
            {
                TreatmentDr = TreatmentDs.Tables[0].Rows[iTreatmentRowCounter];
                if (!IsDataRowNull(TreatmentDr, "openencounter") &&
                    !IsDataRowNull(TreatmentDr, "closeencounter") && !IsDataRowNull(TreatmentDr, "last_encounter_id"))
                {
                    // Condition to check Check for null values in the datarow
                    if (TreatmentDr["openencounter"] != System.DBNull.Value)
                    {
                        if (TreatmentDr["openencounter"].ToString() != "")
                        {
                            ContainsEncounter = true;
                        }
                    }
                    if (TreatmentDr["last_encounter_id"] != System.DBNull.Value)
                    {
                        if (TreatmentDr["last_encounter_id"].ToString() != "")
                        {
                            ContainsEncounter = true;
                        }
                    }
                    if (TreatmentDr["closeencounter"] != System.DBNull.Value)
                    {
                        if (TreatmentDr["closeencounter"].ToString() != "")
                        {
                            ContainsEncounter = true;
                        }
                    }
                }
                if (ContainsEncounter)
                    break;
            }
            return ContainsEncounter;
        }

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * Modified By: Nitin Vikraman		  Date: 20-08-2007
        * 
        * Purpose: This function is called for the creation of Treatment Nodes
        * associated with the  Assessment when the Clinical Context is 
        * Assessment.
        * 
        * Description: 
        * This routine returns Treatment Nodes associated with the  Assessment 
        * when the Clinical Context is Assessment.
        * ********************************************************************/

        private void ProcessAssessmentClinicalContextTreatment(string strCprid, string contextObject, int objectKey,
            int AssessmentId, XmlDocument objJMJXmlDoc, XmlDocument JMJComponentDataDoc, XmlNode objJMJXmlActors,
            XmlDocument objMapperTempXmlDoc)
        {
            // This Function has been tested

            XmlNode objJMJMapperTempTreatment = null;
            XmlNodeList objJMJMapperTempActorList = null;
            DataSet TreatmentDs = new DataSet();
            DataRow TreatmentDr = null;
            try
            {
                objJMJMapperTempTreatment = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Treatment");
                objJMJMapperTempActorList = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Actors").ChildNodes;

                string TreatmentQuery = "exec dbo.jmjdoc_get_treatment @ps_cpr_id,@ps_context_object,@pl_object_key";
                TreatmentDs = GetTreatment(TreatmentQuery, strCprid, contextObject, objectKey, objectKey);
                for (int iTreatmentRowCounter = 0; iTreatmentRowCounter < TreatmentDs.Tables[0].Rows.Count; iTreatmentRowCounter++)
                {
                    TreatmentDr = TreatmentDs.Tables[0].Rows[iTreatmentRowCounter];
                    XmlNodeList TreatmentJMJValueList = null;
                    TreatmentJMJValueList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Treatment/ObjectID[JMJDomain='treatment_id']/JMJValue");
                    bool TreatmentFlag = false;
                    for (int innerCounter = 0; innerCounter < TreatmentJMJValueList.Count; innerCounter++)
                    {
                        if (TreatmentJMJValueList[innerCounter] != null)
                        {
                            if (TreatmentDr["treatmentid"].ToString() == TreatmentJMJValueList[innerCounter].InnerText)
                            {
                                TreatmentFlag = true;
                            }
                        }
                    }
                    if (!TreatmentFlag)
                    {
                        CreateTreatment(objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                            objJMJXmlActors, objJMJMapperTempTreatment, objJMJMapperTempTreatment, objJMJMapperTempActorList, TreatmentDr, AssessmentId, strCprid);
                    }
                }
            }
            catch (Exception ex)
            {
                string msg = "Error while creation of Treatment nodes.";
                throw new Exception(msg, ex);
            }
        }

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * Modified By: Nitin Vikraman		  Date: 20-08-2007
        * 
        * Purpose: This function is called for the creation of Treatment Nodes
        * when clinical context is Patient
        * 
        * Description: 
        * This routine returns the Treatment Nodes nodes not associated with 
        * the Assessments
        *
        * ******************************************************************/

        private void ProcessTreatmentContext(string TreatmentQuery, int objectKey, string strCprid, string contextObject,
            int EncounterId, int AssessmentId, XmlDocument objJMJXmlDoc, XmlDocument JMJComponentDataDoc,
            XmlNode objJMJXmlActors, XmlDocument objMapperTempXmlDoc)
        {
            // This Function has been tested

            XmlNode objJMJMapperTempTreatment = null;
            XmlNodeList objJMJMapperTempActorList = null;
            XmlNodeList EncounterJMJValueNodeList = null;
            DataSet TreatmentDs = new DataSet();
            bool IsAssessmentID = false;
            DataRow TreatmentDr = null;
            try
            {
                objJMJMapperTempTreatment = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Treatment");
                objJMJMapperTempActorList = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Actors").ChildNodes;

                if (TreatmentQuery == "exec dbo.jmjdoc_get_EncDxTreatments @ps_cpr_id,@pl_encounter_id,@pl_problem_id")
                {
                    TreatmentDs = GetTreatment(TreatmentQuery, strCprid, "", EncounterId, objectKey);
                    IsAssessmentID = true;
                    for (int iTreatmentRowCounter = 0; iTreatmentRowCounter < TreatmentDs.Tables[0].Rows.Count; iTreatmentRowCounter++)
                    {
                        TreatmentDr = TreatmentDs.Tables[0].Rows[iTreatmentRowCounter];
                        XmlNodeList TreatmentJMJValueList = null;
                        TreatmentJMJValueList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Treatment/ObjectID[JMJDomain='treatment_id']/JMJValue");
                        bool TreatmentFlag = false;
                        for (int innerCounter = 0; innerCounter < TreatmentJMJValueList.Count; innerCounter++)
                        {
                            if (TreatmentJMJValueList[innerCounter] != null)
                            {
                                if (TreatmentDr["treatmentid"].ToString() == TreatmentJMJValueList[innerCounter].InnerText)
                                {
                                    TreatmentFlag = true;
                                }
                            }
                        }
                        if (!TreatmentFlag)
                        {
                            if (IsAssessmentID)
                            {
                                CreateTreatment(objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                                    objJMJXmlActors, objJMJMapperTempTreatment, objJMJMapperTempTreatment, objJMJMapperTempActorList, TreatmentDr, AssessmentId, strCprid);
                            }
                            else
                            {
                                CreateTreatment(objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                                    objJMJXmlActors, objJMJMapperTempTreatment, objJMJMapperTempTreatment, objJMJMapperTempActorList, TreatmentDr, 0, strCprid);
                            }

                        }
                    }
                }
                else
                {
                    EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                    for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                    {
                        EncounterId = Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText);
                        TreatmentDs = GetTreatment(TreatmentQuery, strCprid, contextObject, EncounterId, objectKey);
                        for (int iTreatmentRowCounter = 0; iTreatmentRowCounter < TreatmentDs.Tables[0].Rows.Count; iTreatmentRowCounter++)
                        {
                            TreatmentDr = TreatmentDs.Tables[0].Rows[iTreatmentRowCounter];
                            XmlNodeList TreatmentJMJValueList = null;
                            TreatmentJMJValueList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Treatment/ObjectID/JMJValue");
                            bool TreatmentFlag = false;
                            for (int innerCounter = 0; innerCounter < TreatmentJMJValueList.Count; innerCounter++)
                            {
                                if (TreatmentJMJValueList[innerCounter] != null)
                                {
                                    if (TreatmentDr["treatmentid"].ToString() == TreatmentJMJValueList[innerCounter].InnerText)
                                    {
                                        TreatmentFlag = true;
                                    }
                                }
                            }
                            if (!TreatmentFlag)
                            {
                                if (IsAssessmentID)
                                {
                                    CreateTreatment(objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                                        objJMJXmlActors, objJMJMapperTempTreatment, objJMJMapperTempTreatment, objJMJMapperTempActorList, TreatmentDr, AssessmentId, strCprid);
                                }
                                else
                                {
                                    CreateTreatment(objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                                        objJMJXmlActors, objJMJMapperTempTreatment, objJMJMapperTempTreatment, objJMJMapperTempActorList, TreatmentDr, 0, strCprid);
                                }

                            }
                        }
                    }
                }


            }
            catch (Exception ex)
            {
                string msg = "Error while creation of Treatment nodes.";
                throw new Exception(msg, ex);
            }
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * Modified By: Nitin Vikraman		  Date: 20-08-2007
        * 
        * Purpose: This function is called for the creation of Treatment Nodes
        *  for the Treatment Clinical Context
        * 
        * Description: 
        * This routine returns Treatment Nodes ,TreatmentNote  for the
        * Treatment Clinical Context
        *
        * ********************************************************************/
        private void ProcessTreatmentClincalContextTreatment(string strCprid, string contextObject, int objectKey,
            int AssessmentId, XmlDocument objJMJXmlDoc, XmlDocument JMJComponentDataDoc,
            XmlNode objJMJXmlActors, XmlDocument objMapperTempXmlDoc)
        {
            // This Function has been tested

            XmlNode objJMJMapperTempTreatment = null;
            XmlNodeList objJMJMapperTempActorList = null;
            DataSet TreatmentDs = new DataSet();
            DataRow TreatmentDr = null;
            try
            {
                objJMJMapperTempTreatment = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Treatment");
                objJMJMapperTempActorList = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Actors").ChildNodes;
                string TreatmentQuery = "exec dbo.jmjdoc_get_treatment @ps_cpr_id,@ps_context_object,@pl_object_key";
                TreatmentDs = GetTreatment(TreatmentQuery, strCprid, contextObject, objectKey, objectKey);

                TreatmentDr = TreatmentDs.Tables[0].Rows[0];
                XmlNodeList TreatmentJMJValueList = null;
                TreatmentJMJValueList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Treatment/ObjectID[JMJDomain='treatment_id']/JMJValue");
                bool TreatmentFlag = false;
                for (int innerCounter = 0; innerCounter < TreatmentJMJValueList.Count; innerCounter++)
                {
                    if (TreatmentJMJValueList[innerCounter] != null)
                    {
                        if (TreatmentDr["treatmentid"].ToString() == TreatmentJMJValueList[innerCounter].InnerText)
                        {
                            TreatmentFlag = true;
                        }
                    }
                }
                if (!TreatmentFlag)
                {

                    CreateTreatment(objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                        objJMJXmlActors, objJMJMapperTempTreatment, objJMJMapperTempTreatment, objJMJMapperTempActorList, TreatmentDr, AssessmentId, strCprid);


                }
            }



            catch (Exception ex)
            {
                string msg = "Error while creation of Treatment nodes.";
                throw new Exception(msg, ex);
            }
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * Modified By: Nitin Vikraman		  Date: 20-08-2007
        * 
        * Purpose: This function is called for the creation of Treatment Nodes
        * which are associated with the Assessments
        * 
        * Description: 
        * This routine returns Treatment Nodes which are related to 
        * assessment for the clinical context is Encounter
        *
        * ********************************************************************/
        private void ProcessEncounterClincalContextEncDxTreatment(string strCprid, int EncounterId,
            int AssessmentId, XmlDocument objJMJXmlDoc, XmlDocument JMJComponentDataDoc,
            XmlNode objJMJXmlActors, XmlDocument objMapperTempXmlDoc)
        {
            // This Function has been tested

            XmlNode objJMJMapperTempTreatment = null;
            XmlNodeList objJMJMapperTempActorList = null;
            DataSet TreatmentDs = new DataSet();
            DataRow TreatmentDr = null;
            try
            {
                objJMJMapperTempTreatment = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Treatment");
                objJMJMapperTempActorList = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Actors").ChildNodes;
                string TreatmentQuery = "exec dbo.jmjdoc_get_EncDxTreatments @ps_cpr_id,@pl_encounter_id,@pl_problem_id";
                TreatmentDs = GetTreatment(TreatmentQuery, strCprid, "", EncounterId, AssessmentId);
                for (int iCounter = 0; iCounter < TreatmentDs.Tables[0].Rows.Count; iCounter++)
                {
                    TreatmentDr = TreatmentDs.Tables[0].Rows[iCounter];
                    XmlNodeList TreatmentJMJValueList = null;
                    TreatmentJMJValueList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Treatment/ObjectID[JMJDomain='treatment_id']/JMJValue");
                    bool TreatmentFlag = false;
                    for (int innerCounter = 0; innerCounter < TreatmentJMJValueList.Count; innerCounter++)
                    {
                        if (TreatmentJMJValueList[innerCounter] != null)
                        {
                            if (TreatmentDr["treatmentid"].ToString() == TreatmentJMJValueList[innerCounter].InnerText)
                            {
                                TreatmentFlag = true;
                            }
                        }
                    }
                    if (!TreatmentFlag)
                    {
                        CreateTreatment(objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                            objJMJXmlActors, objJMJMapperTempTreatment, objJMJMapperTempTreatment, objJMJMapperTempActorList, TreatmentDr, AssessmentId, strCprid);
                    }
                }
            }



            catch (Exception ex)
            {
                string msg = "Error while creation of Treatment nodes.";
                throw new Exception(msg, ex);
            }
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * Modified By Nitin Vikraman		  Date: 20-08-2007
        * 
        * Purpose: This function is called for the creation of Treatment Nodes
        * which are not associated with the Assessments
        * 
        * Description: 
        * This routine returns Treatment Nodes which are not related to 
        * assessment for the clinical context is Encounter
        *
        * ********************************************************************/
        private void ProcessEncounterClincalContextTreatment(string strCprid, string ContextObject, int ObjectKey,
            XmlDocument objJMJXmlDoc, XmlDocument JMJComponentDataDoc, XmlNode objJMJXmlActors, XmlDocument objMapperTempXmlDoc)
        {
            // This Function has been tested

            XmlNode objJMJMapperTempTreatment = null;
            XmlNodeList objJMJMapperTempActorList = null;
            DataSet TreatmentDs = new DataSet();
            DataRow TreatmentDr = null;
            try
            {
                objJMJMapperTempTreatment = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Treatment");
                objJMJMapperTempActorList = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Actors").ChildNodes;
                string TreatmentQuery = "exec dbo.jmjdoc_get_treatment @ps_cpr_id,@ps_context_object,@pl_object_key";
                TreatmentDs = GetTreatment(TreatmentQuery, strCprid, "Encounter", ObjectKey, 0);
                for (int iCounter = 0; iCounter < TreatmentDs.Tables[0].Rows.Count; iCounter++)
                {
                    TreatmentDr = TreatmentDs.Tables[0].Rows[iCounter];
                    XmlNodeList TreatmentJMJValueList = null;
                    TreatmentJMJValueList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Treatment/ObjectID[JMJDomain='treatment_id']/JMJValue");
                    bool TreatmentFlag = false;
                    for (int innerCounter = 0; innerCounter < TreatmentJMJValueList.Count; innerCounter++)
                    {
                        if (TreatmentJMJValueList[innerCounter] != null)
                        {
                            if (TreatmentDr["treatmentid"].ToString() == TreatmentJMJValueList[innerCounter].InnerText)
                            {
                                TreatmentFlag = true;
                            }
                        }
                    }
                    if (!TreatmentFlag)
                    {
                        CreateTreatment(objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                            objJMJXmlActors, objJMJMapperTempTreatment, objJMJMapperTempTreatment, objJMJMapperTempActorList, TreatmentDr, 0, strCprid);
                    }
                }
            }



            catch (Exception ex)
            {
                string msg = "Error while creation of Treatment nodes.";
                throw new Exception(msg, ex);
            }
        }

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function modify the nodes of the Encounter with new values
        * 
        * Description: 
        * This routine returns Encounter node with new values
        *
        * ********************************************************************/
        private void UpdateEncounter(XmlDocument objJMJXmlDoc, XmlNode objJMJEncounterNode,
            XmlNode objJMJXmlActors, XmlNode objJMJMapperTempEncounter, XmlNodeList objJMJMapperTempActorList,
            DataRow EncounterDr, DataSet EncounterNoteDs)
        {
            // This Function has been tested
            try
            {
                if (objJMJMapperTempEncounter.ChildNodes.Count > 0 &&
                    objJMJMapperTempEncounter.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempEncounter.Attributes.Count > 0)
                    {
                        if (objJMJMapperTempEncounter.Attributes["EncounterID"] != null)
                        {
                            if (objJMJMapperTempEncounter.Attributes["EncounterID"].Value != "")
                            {
                                if (objJMJEncounterNode.Attributes["EncounterID"] != null)
                                {
                                    objJMJEncounterNode.Attributes["EncounterID"].Value = EncounterDr["encounterid"].ToString();
                                }
                                else
                                {
                                    XmlAttribute objEncounterAttrib = objJMJXmlDoc.CreateAttribute("EncounterID");
                                    objEncounterAttrib.Value = EncounterDr[objJMJMapperTempEncounter.Attributes["EncounterID"].Value].ToString();
                                    //	objJMJXmlEncounter.Attributes.Append(objEncounterAttrib);
                                }
                            }
                        }
                    }
                    if (objJMJMapperTempEncounter.Name == "InpatientStatus" ||
                        objJMJMapperTempEncounter.Name == "OutpatientStatus" ||
                        objJMJMapperTempEncounter.Name == "IndirectEncounterStatus" ||
                        objJMJMapperTempEncounter.Name == "OtherEncounterStatus")
                    {
                        //DataRow dr=EncounterDs.Tables[0].Rows[0];
                        if (!IsDataRowNull(EncounterDr, "encountermode"))
                        {
                            // Condition for creating Patient Status nodes
                            if (EncounterDr["encountermode"] != System.DBNull.Value)
                            {
                                string path = "";
                                if (objJMJMapperTempEncounter.Name == "InpatientStatus")
                                {

                                    if (EncounterDr["encountermode"].ToString() == "H")
                                    {
                                        path = objJMJMapperTempEncounter.Name;
                                        if (objJMJEncounterNode.SelectSingleNode(path) == null)
                                        {


                                            UpdateEncounterChildNodes(objJMJXmlDoc, objJMJEncounterNode,
                                                objJMJXmlActors, objJMJMapperTempEncounter, objJMJMapperTempActorList,
                                                EncounterDr, EncounterNoteDs);
                                        }

                                    }

                                }

                                else if (objJMJMapperTempEncounter.Name == "OutpatientStatus")
                                {
                                    if (EncounterDr["encountermode"].ToString() == "D")
                                    {
                                        path = objJMJMapperTempEncounter.Name;
                                        if (objJMJEncounterNode.SelectSingleNode(path) == null)
                                        {

                                            UpdateEncounterChildNodes(objJMJXmlDoc, objJMJEncounterNode,
                                                objJMJXmlActors, objJMJMapperTempEncounter, objJMJMapperTempActorList,
                                                EncounterDr, EncounterNoteDs);
                                        }


                                    }
                                }
                                else if (objJMJMapperTempEncounter.Name == "IndirectEncounterStatus")
                                {
                                    if (EncounterDr["encountermode"].ToString() == "I")
                                    {

                                        path = objJMJMapperTempEncounter.Name;
                                        if (objJMJEncounterNode.SelectSingleNode(path) == null)
                                        {


                                            UpdateEncounterChildNodes(objJMJXmlDoc, objJMJEncounterNode,
                                                objJMJXmlActors, objJMJMapperTempEncounter, objJMJMapperTempActorList,
                                                EncounterDr, EncounterNoteDs);
                                        }


                                    }
                                }
                                else if (objJMJMapperTempEncounter.Name == "OtherEncounterStatus")
                                {
                                    if (EncounterDr["encountermode"].ToString() != "H" && EncounterDr["encountermode"].ToString() != "I" &&
                                        EncounterDr["encountermode"].ToString() != "D")
                                    {
                                        path = objJMJMapperTempEncounter.Name;
                                        if (objJMJEncounterNode.SelectSingleNode(path) == null)
                                        {

                                            UpdateEncounterChildNodes(objJMJXmlDoc, objJMJEncounterNode,
                                                objJMJXmlActors, objJMJMapperTempEncounter, objJMJMapperTempActorList,
                                                EncounterDr, EncounterNoteDs);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (objJMJMapperTempEncounter.Name == "EncounterNote")
                    {
                        string path = objJMJMapperTempEncounter.Name;
                        if (objJMJEncounterNode.SelectSingleNode(path) == null)
                        {
                            DataRow EncounterNoteDr = null;
                            for (int iEncounterNote = 0; iEncounterNote < EncounterNoteDs.Tables[0].Rows.Count; iEncounterNote++)
                            {
                                EncounterNoteDr = EncounterNoteDs.Tables[0].Rows[iEncounterNote];
                                XmlNode objJMJEncounterNote = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objJMJMapperTempEncounter.Name, null);
                                objJMJEncounterNode.AppendChild(objJMJEncounterNote);
                                CreateEncounterNote(objJMJXmlDoc, objJMJEncounterNote, objJMJMapperTempEncounter, EncounterNoteDr);
                            }
                        }
                    }
                    else
                    {
                        UpdateEncounterChildNodes(objJMJXmlDoc, objJMJEncounterNode,
                            objJMJXmlActors, objJMJMapperTempEncounter, objJMJMapperTempActorList,
                            EncounterDr, EncounterNoteDs);



                    }

                }
            }
            catch (Exception ex)
            {
                string msg = "Error while updating the Encounter Nodes";
                throw new Exception(msg, ex);
            }

        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * Modified By: Nitin Vikraman		  Date: 20-08-2007
        * 
        * Purpose: This function modify the child nodes of the Encounter with new values
        * 
        * Description: 
        * This routine returns the child node of Encounter node with new values
        *
        * ********************************************************************/
        private void UpdateEncounterChildNodes(XmlDocument objJMJXmlDoc, XmlNode objJMJEncounterNode,
            XmlNode objJMJXmlActors, XmlNode objJMJMapperTempEncounter, XmlNodeList objJMJMapperTempActorList,
            DataRow EncounterDr, DataSet EncounterNoteDs)
        {
            foreach (XmlNode objTempEncounter in objJMJMapperTempEncounter.ChildNodes)
            {
                if (objTempEncounter.NodeType == XmlNodeType.Element)
                {
                    string path = objTempEncounter.Name;
                    if (objJMJEncounterNode.SelectSingleNode(path) == null)
                    {
                        // Create a new Node
                        XmlNode objNewEncounterNode = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objTempEncounter.Name, "");
                        objJMJEncounterNode.AppendChild(objNewEncounterNode);
                        UpdateEncounter(objJMJXmlDoc, objJMJEncounterNode.SelectSingleNode(path), objJMJXmlActors,
                            objTempEncounter, objJMJMapperTempActorList, EncounterDr, EncounterNoteDs);
                        if (!objNewEncounterNode.HasChildNodes)
                        {
                            objJMJEncounterNode.RemoveChild(objNewEncounterNode);
                        }
                    }
                    else
                    {
                        UpdateEncounter(objJMJXmlDoc, objJMJEncounterNode.SelectSingleNode(path), objJMJXmlActors,
                            objTempEncounter, objJMJMapperTempActorList, EncounterDr, EncounterNoteDs);
                    }

                }
                else if (objTempEncounter.NodeType == XmlNodeType.Text
                    && objTempEncounter.Name == "#text")
                {

                    if (!IsDataRowNull(EncounterDr, objTempEncounter.InnerText))
                    {
                        bool ContainsFlag = false;
                        if (EncounterDr[objTempEncounter.InnerText] != System.DBNull.Value)
                        {
                            if (objTempEncounter.InnerText == "encounterdate" ||
                                objTempEncounter.InnerText == "encounterenddate" ||
                                objTempEncounter.InnerText == "dischargedate")
                            {
                                objJMJEncounterNode.InnerText = Convert.ToDateTime(EncounterDr[objTempEncounter.InnerText]
                                    .ToString()).ToString("u");
                            }
                            else if (objTempEncounter.InnerText == "newpatientflag")
                            {
                                if (EncounterDr[objTempEncounter.InnerText].ToString() == "N")
                                {
                                    objJMJEncounterNode.InnerText = "New";
                                }
                                else
                                {
                                    objJMJEncounterNode.InnerText = "Established";
                                }

                            }
                            else if (objTempEncounter.InnerText == "attendingdoctor_actorid")
                            {
                                objJMJEncounterNode.InnerText = EncounterDr[objTempEncounter.InnerText].ToString();
                                // Code for creation of Actor Nodes
                                XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                int jCounter = 0;
                                for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                {
                                    if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJEncounterNode.InnerText)
                                    {
                                        ContainsFlag = true;
                                        break;
                                    }
                                }
                                if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                {
                                    for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                    {
                                        if (objJMJMapperTempActorList[iCounter].Name == "ActorAttendingDoctor")
                                        {
                                            CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                EncounterDr);
                                        }
                                    }
                                }
                            }
                            else if (objTempEncounter.InnerText == "referringdoctor_actorid")
                            {
                                objJMJEncounterNode.InnerText = EncounterDr[objTempEncounter.InnerText].ToString();
                                // Code for creation of Actor Nodes
                                XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                int jCounter = 0;
                                for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                {
                                    if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJEncounterNode.InnerText)
                                    {
                                        ContainsFlag = true;
                                        break;
                                    }
                                }
                                if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                {
                                    for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                    {
                                        if (objJMJMapperTempActorList[iCounter].Name == "ActorReferringDoctor")
                                        {
                                            CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                EncounterDr);
                                        }
                                    }
                                }
                            }
                            else if (objTempEncounter.InnerText == "supervisingdoctor_actorid")
                            {
                                objJMJEncounterNode.InnerText = EncounterDr[objTempEncounter.InnerText].ToString();
                                // Code for creation of Actor Nodes
                                XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                int jCounter = 0;
                                for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                {
                                    if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJEncounterNode.InnerText)
                                    {
                                        ContainsFlag = true;
                                        break;
                                    }
                                }
                                if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                {
                                    for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                    {
                                        if (objJMJMapperTempActorList[iCounter].Name == "ActorSupervisingDoctor")
                                        {
                                            CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                EncounterDr);
                                        }
                                    }
                                }
                            }

                            else
                            {
                                objJMJEncounterNode.InnerText = EncounterDr[objTempEncounter.InnerText].ToString();
                            }
                        }

                    }
                }
            }
        }

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the ceration ofAssessment Nodes
        * and Treatment for the Patient Clincal Context
        * 
        * Description: 
        * This routine returns Assessment Nodes associated with the Encounter
        * when the clinical context Patient. This rountine returns treatment
        * associated with the assessments .
        *
        * ******************************************************************/

        private void ProcessPatientEncounterAssessmentContext(int objectKey, string strCprid,
            XmlDocument objJMJXmlDoc, XmlDocument JMJComponentDataDoc, XmlNode objJMJXmlActors,
            XmlDocument objMapperTempXmlDoc)
        {
            // This Function has been tested
            // This function is used by Patient and Encounter Context
            DataSet AssessmentDs = new DataSet();
            DataSet EncounterDs = new DataSet();
            DataSet AssessmentNoteDs = new DataSet();
            DataSet EncounterNoteDs = new DataSet();
            XmlDocument objTreatmentDoc = new XmlDocument();
            XmlNodeList EncounterJMJValueNodeList = null;
            XmlNodeList objJMJMapperTempActorList = null;
            XmlNodeList AssessmentJMJValueNodeList = null;
            XmlNodeList AssessmentIDList = null;

            DataRow AssessmentDr = null;
            DataRow EncounterDr = null;

            XmlNode objJMJMapperTempAssessment = null;

            int AssessmentProblemId = 0;
            int AssessmentId = 0;
            int OpenEncounter = 0;
            int CloseEncounter = 0;
            int AssessmentOpenEncounter = 0;
            try
            {
                AssessmentDs = GetAssessment(strCprid, "Encounter", objectKey);
                if (AssessmentDs != null)
                {
                    if (AssessmentDs.Tables.Count > 0)
                    {
                        if (AssessmentDs.Tables[0].Rows.Count > 0)
                        {

                            objJMJMapperTempAssessment = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Assessment");
                            objJMJMapperTempActorList = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Actors").ChildNodes;
                            for (int iAssessmentRowCounter = 0; iAssessmentRowCounter < AssessmentDs.Tables[0].Rows.Count; iAssessmentRowCounter++)
                            {
                                // Section for adding conditions on Creation of encounter assessments
                                AssessmentDr = AssessmentDs.Tables[0].Rows[iAssessmentRowCounter];

                                if (!IsDataRowNull(AssessmentDr, "problemid"))
                                {
                                    if (AssessmentDr["problemid"] != System.DBNull.Value)
                                    {
                                        AssessmentProblemId = Convert.ToInt32(AssessmentDr["problemid"].ToString());
                                        AssessmentNoteDs = getProgress(strCprid, "Assessment", AssessmentProblemId, null, null, null);
                                    }
                                }
                                if (!IsDataRowNull(AssessmentDr, "openencounter"))
                                {
                                    if (AssessmentDr["openencounter"] != System.DBNull.Value)
                                    {
                                        OpenEncounter = Convert.ToInt32(AssessmentDr["openencounter"].ToString());
                                        // Check if the Encounter exist with Encounter.encounterid=OpenEncounter

                                        EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                                        bool ContainsEncounter = false;
                                        for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                                        {
                                            if (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) == OpenEncounter)
                                            {
                                                ContainsEncounter = true;
                                                // Modify the Encounter node
                                                EncounterDs = GetEncounter(strCprid, OpenEncounter);
                                                if (EncounterDs != null)
                                                {
                                                    if (EncounterDs.Tables.Count > 0)
                                                    {
                                                        if (EncounterDs.Tables[0].Rows.Count > 0)
                                                        {
                                                            EncounterDr = EncounterDs.Tables[0].Rows[0];
                                                            EncounterNoteDs = this.getProgress(strCprid, "Encounter", OpenEncounter, null, null, null);
                                                            XmlNode JMJEncounterNode = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter];
                                                            if (Convert.ToInt32(JMJEncounterNode.Attributes["EncounterID"].Value) == Convert.ToInt32(EncounterDr["encounterid"].ToString()))
                                                            {
                                                                UpdateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter],
                                                                    objJMJXmlActors, objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Encounter"),
                                                                    objJMJMapperTempActorList, EncounterDr, EncounterNoteDs);
                                                                break;
                                                            }
                                                        }
                                                    }
                                                }

                                            }
                                            else if (ContainsEncounter == false && ((iCounter + 1) == EncounterJMJValueNodeList.Count)
                                                && (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) != OpenEncounter))
                                            {
                                                ProcessEncounterContext(OpenEncounter, strCprid, objJMJXmlDoc, objJMJXmlActors, objMapperTempXmlDoc);
                                                ProcessPatientEncounterAssessmentContext(OpenEncounter, strCprid, objJMJXmlDoc, JMJComponentDataDoc,
                                                    objJMJXmlActors, objMapperTempXmlDoc);
                                            }
                                        }

                                    }
                                }
                                if (!IsDataRowNull(AssessmentDr, "closeencounter"))
                                {
                                    if (AssessmentDr["closeencounter"] != System.DBNull.Value)
                                    {
                                        CloseEncounter = Convert.ToInt32(AssessmentDr["closeencounter"].ToString());
                                        // Check if the Encounter exist with Encounter.encounterid=OpenEncounter
                                        EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                                        bool ContainsEncounter = false;
                                        for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                                        {
                                            if (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) == CloseEncounter)
                                            {
                                                ContainsEncounter = true;

                                                break;
                                            }
                                            else if (ContainsEncounter == false && ((iCounter + 1) == EncounterJMJValueNodeList.Count)
                                                && (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) != CloseEncounter))
                                            {
                                                ProcessEncounterContext(CloseEncounter, strCprid, objJMJXmlDoc, objJMJXmlActors, objMapperTempXmlDoc);
                                                ProcessPatientEncounterAssessmentContext(CloseEncounter, strCprid, objJMJXmlDoc, JMJComponentDataDoc,
                                                    objJMJXmlActors, objMapperTempXmlDoc);
                                            }
                                        }

                                    }
                                }
                                // Create Assessment Node
                                bool ContainsAssessment = false;
                                AssessmentJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Assessment/ObjectID/JMJValue");
                                for (int iCounter = 0; iCounter < AssessmentJMJValueNodeList.Count; iCounter++)
                                {

                                    if (AssessmentProblemId == Convert.ToInt32(AssessmentJMJValueNodeList[iCounter].InnerText))
                                    {
                                        ContainsAssessment = true;
                                        // Modify the Assessment Node
                                    }
                                }
                                if (!ContainsAssessment)
                                {
                                    CreateAssessment(objJMJXmlDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                                        objJMJXmlActors, objJMJMapperTempAssessment, objJMJMapperTempActorList,
                                        AssessmentDr, AssessmentNoteDs);

                                }

                                string TreatmentQuery = "exec dbo.jmjdoc_get_EncDxTreatments @ps_cpr_id,@pl_encounter_id,@pl_problem_id";
                                // Generate the associated Treatment Nodes
                                AssessmentIDList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Assessment");
                                AssessmentJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Assessment/ObjectID/JMJValue");
                                XmlNodeList AssessmentNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Assessment/OpenEncounter");
                                for (int iAssessmenRowCounter = 0; iAssessmenRowCounter < AssessmentJMJValueNodeList.Count; iAssessmenRowCounter++)
                                {
                                    //AssessmentProblemId
                                    if (AssessmentJMJValueNodeList[iAssessmenRowCounter].InnerText != "")
                                    {
                                        AssessmentId = Convert.ToInt32(AssessmentIDList[iAssessmenRowCounter].Attributes["AssessmentID"].Value);
                                        AssessmentProblemId = Convert.ToInt32(AssessmentJMJValueNodeList[iAssessmenRowCounter].InnerText);
                                        AssessmentOpenEncounter = Convert.ToInt32(AssessmentNodeList[iAssessmenRowCounter].InnerText);
                                        ProcessTreatmentContext(TreatmentQuery, AssessmentProblemId, strCprid, "", AssessmentOpenEncounter,
                                            AssessmentId, objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlActors, objMapperTempXmlDoc);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                string msg = "Error while creating Assessment Nodes. Updated Error messages";
                throw new Exception(msg + ex.StackTrace, ex);
            }


        }
        //		private void ProcessEncounterAssessmentContext(int objectKey,string strCprid,
        //			XmlDocument objJMJXmlDoc,XmlDocument JMJComponentDataDoc,
        //			XmlNode objJMJXmlActors, XmlDocument objMapperTempXmlDoc)
        //		{
        //			// This Function has been tested
        //			// This function is used by Patient and Encounter Context
        //			DataSet AssessmentDs=new DataSet();
        //			DataSet EncounterDs=new DataSet();
        //			DataSet AssessmentNoteDs=new DataSet();
        //			DataSet EncounterNoteDs=new DataSet();
        //			XmlDocument objTreatmentDoc=new XmlDocument();
        //			XmlNodeList EncounterJMJValueNodeList=null;
        //			XmlNodeList objJMJMapperTempActorList=null;
        //			XmlNodeList AssessmentJMJValueNodeList=null;
        //			XmlNodeList AssessmentIDList=null;
        //
        //			DataRow AssessmentDr=null;
        //			DataRow EncounterDr=null;
        //	
        //			XmlNode objJMJMapperTempAssessment=null;
        //			
        //			int AssessmentProblemId=0;
        //			int AssessmentId=0;
        //			int OpenEncounter=0;
        //			int CloseEncounter=0;
        //			int AssessmentOpenEncounter=0;
        //			try
        //			{
        //				AssessmentDs=GetAssessment(strCprid,"Encounter",objectKey);
        //				if(AssessmentDs!=null)
        //				{
        //					if(AssessmentDs.Tables.Count>0)
        //					{
        //						if(AssessmentDs.Tables[0].Rows.Count>0 )
        //						{
        //
        //							objJMJMapperTempAssessment=objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Assessment");
        //							objJMJMapperTempActorList=objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Actors").ChildNodes;
        //							for(int iAssessmentRowCounter=0;iAssessmentRowCounter<AssessmentDs.Tables[0].Rows.Count;iAssessmentRowCounter++)
        //							{
        //								// Section for adding conditions on Creation of encounter assessments
        //								AssessmentDr=AssessmentDs.Tables[0].Rows[iAssessmentRowCounter];
        //
        //								if(!IsDataRowNull(AssessmentDr,"problemid"))
        //								{
        //									if(AssessmentDr["problemid"]!=System.DBNull.Value)
        //									{
        //										AssessmentProblemId= Convert.ToInt32(AssessmentDr["problemid"].ToString());
        //										AssessmentNoteDs=getProgress(strCprid,"Assessment",AssessmentProblemId,null,null,null);
        //									}
        //								}
        //								if(!IsDataRowNull(AssessmentDr,"openencounter"))
        //								{
        //									if(AssessmentDr["openencounter"]!=System.DBNull.Value)
        //									{
        //										OpenEncounter=Convert.ToInt32( AssessmentDr["openencounter"].ToString());
        //										// Check if the Encounter exist with Encounter.encounterid=OpenEncounter
        //									
        //										EncounterJMJValueNodeList=objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
        //										bool ContainsEncounter=false;
        //										for(int iCounter=0;iCounter<EncounterJMJValueNodeList.Count;iCounter++)
        //										{
        //											if(Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText)==OpenEncounter)
        //											{
        //												ContainsEncounter=true;
        //												// Modify the Encounter node
        //												EncounterDs=GetEncounter(strCprid,OpenEncounter);
        //												if(EncounterDs!=null)
        //												{
        //													if(EncounterDs.Tables.Count>0)
        //													{
        //														if(EncounterDs.Tables[0].Rows.Count>0)
        //														{
        //															EncounterDr=EncounterDs.Tables[0].Rows[0];
        //															EncounterNoteDs = this.getProgress(strCprid,"Encounter",OpenEncounter,null,null,null);
        //															XmlNode JMJEncounterNode=objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter];
        //															if(Convert.ToInt32(JMJEncounterNode.Attributes["EncounterID"].Value)==Convert.ToInt32( EncounterDr["encounterid"].ToString()))
        //															{
        //																UpdateEncounter(objJMJXmlDoc,objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter],
        //																	objJMJXmlActors,objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Encounter"),
        //																	objJMJMapperTempActorList,EncounterDr,EncounterNoteDs);
        //																break;
        //															}
        //														}
        //													}
        //												}
        //												
        //									
        //											}
        //											else if(ContainsEncounter==false && ((iCounter+1)==EncounterJMJValueNodeList.Count)
        //												&& (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText)!=OpenEncounter))
        //											{
        //												ProcessEncounterContext(OpenEncounter,strCprid,objJMJXmlDoc,objJMJXmlActors,objMapperTempXmlDoc);
        //												ProcessEncounterAssessmentContext(OpenEncounter,strCprid,objJMJXmlDoc,JMJComponentDataDoc,
        //													objJMJXmlActors,objMapperTempXmlDoc);
        //											}
        //										}
        //							
        //									}
        //								}
        //								if(!IsDataRowNull(AssessmentDr,"closeencounter"))
        //								{
        //									if(AssessmentDr["closeencounter"]!=System.DBNull.Value)
        //									{
        //										CloseEncounter=Convert.ToInt32( AssessmentDr["closeencounter"].ToString());
        //										// Check if the Encounter exist with Encounter.encounterid=OpenEncounter
        //										EncounterJMJValueNodeList=objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
        //										bool ContainsEncounter=false;
        //										for(int iCounter=0;iCounter<EncounterJMJValueNodeList.Count;iCounter++)
        //										{
        //											if(Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText)==CloseEncounter)
        //											{
        //												ContainsEncounter=true;
        //												
        //												//EncounterDs=GetEncounter(strCprid,CloseEncounter);
        //												//EncounterDr=EncounterDs.Tables[0].Rows[0];
        //												break;
        //											}
        //											else if(ContainsEncounter==false && ((iCounter+1)==EncounterJMJValueNodeList.Count)
        //												&& (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText)!=CloseEncounter))
        //											{
        //												ProcessEncounterContext(CloseEncounter,strCprid,objJMJXmlDoc,objJMJXmlActors,objMapperTempXmlDoc);
        //												ProcessEncounterAssessmentContext(CloseEncounter,strCprid,objJMJXmlDoc,JMJComponentDataDoc,
        //												objJMJXmlActors,objMapperTempXmlDoc);
        //											}
        //										}
        //							
        //									}
        //								}
        //								// Create Assessment Node
        //								bool ContainsAssessment=false;
        //								AssessmentJMJValueNodeList=objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Assessment/ObjectID/JMJValue");
        //								for(int iCounter=0;iCounter<AssessmentJMJValueNodeList.Count;iCounter++)
        //								{
        //						
        //									if(AssessmentProblemId==Convert.ToInt32(AssessmentJMJValueNodeList[iCounter].InnerText))
        //									{
        //										ContainsAssessment=true;
        //										// Modify the Assessment Node
        //									}
        //								}
        //								if(!ContainsAssessment )
        //								{
        //									CreateAssessment(objJMJXmlDoc,objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
        //										objJMJXmlActors,objJMJMapperTempAssessment,objJMJMapperTempActorList,
        //										AssessmentDr,AssessmentNoteDs);
        //
        //								}
        //						
        //								string TreatmentQuery="exec dbo.jmjdoc_get_EncDxTreatments @ps_cpr_id,@pl_encounter_id,@pl_problem_id";
        //								// Generate the associated Treatment Nodes
        //								AssessmentIDList=objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Assessment");
        //								AssessmentJMJValueNodeList	= objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Assessment/ObjectID/JMJValue");
        //								XmlNodeList AssessmentNodeList=objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Assessment/OpenEncounter");
        //								for(int iAssessmenRowCounter=0;iAssessmenRowCounter<AssessmentJMJValueNodeList.Count;iAssessmenRowCounter++)
        //								{
        //									//AssessmentProblemId
        //									if(AssessmentJMJValueNodeList[iAssessmenRowCounter].InnerText!="")
        //									{
        //										AssessmentId=Convert.ToInt32(AssessmentIDList[iAssessmenRowCounter].Attributes["AssessmentID"].Value);
        //										AssessmentProblemId=Convert.ToInt32(AssessmentJMJValueNodeList[iAssessmenRowCounter].InnerText);
        //										AssessmentOpenEncounter=Convert.ToInt32(AssessmentNodeList[iAssessmenRowCounter].InnerText);
        //										ProcessTreatmentContext(TreatmentQuery,AssessmentProblemId,strCprid,"",AssessmentOpenEncounter,
        //											AssessmentId,objJMJXmlDoc,JMJComponentDataDoc,objJMJXmlActors,objMapperTempXmlDoc);
        //									}
        //								}
        //							}	
        //						}
        //					}
        //				}
        //			}
        //			catch(Exception ex)
        //			{
        //				string msg = "Error while creating Assessment Nodes. Updated Error messages";
        //				throw new Exception(msg + ex.StackTrace, ex);
        //			}
        //			
        //			
        //		}

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * Modified By: Nitin Vikraman		  Date: 21-08-2007
        * 
        * Purpose: This function is called for the creation of Assessment Nodes
        * , AssessmentNote and associated Treatments for the Assessment Clinical
        * Context
        * 
        * Description: 
        * This routine returns Assessment Nodes , AssessmentNote and associated 
        * Treatments for the Assessment Clinical Context. 
        *
        * ********************************************************************/
        private void ProcessAssessmentClinicalContext(int objectKey, string strCprid,
            XmlDocument objJMJXmlDoc, XmlDocument JMJComponentDataDoc, XmlNode objJMJXmlActors,
            XmlDocument objMapperTempXmlDoc)
        {
            DataSet AssessmentDs = new DataSet();
            DataSet EncounterDs = new DataSet();
            DataSet AssessmentNoteDs = new DataSet();

            DataSet EncounterNoteDs = new DataSet();

            XmlDocument objTreatmentDoc = new XmlDocument();
            XmlNodeList EncounterJMJValueNodeList = null;
            XmlNodeList AssessmentJMJValueNodeList = null;
            XmlNodeList objJMJMapperTempActorList = null;

            DataRow AssessmentDr = null;
            DataRow EncounterDr = null;

            XmlNode objJMJMapperTempAssessment = null;

            int AssessmentProblemId = 0;
            int OpenEncounter = 0;
            int CloseEncounter = 0;
            try
            {
                AssessmentDs = GetAssessment(strCprid, "Assessment", objectKey);
                if (AssessmentDs.Tables[0].Rows.Count > 0)
                {
                    objJMJMapperTempAssessment = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Assessment");
                    objJMJMapperTempActorList = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Actors").ChildNodes;
                    AssessmentDr = AssessmentDs.Tables[0].Rows[0];
                    if (!IsDataRowNull(AssessmentDr, "problemid"))
                    {
                        if (AssessmentDr["problemid"] != System.DBNull.Value)
                        {
                            AssessmentProblemId = Convert.ToInt32(AssessmentDr["problemid"].ToString());
                            AssessmentNoteDs = getProgress(strCprid, "Assessment", AssessmentProblemId, null, null, null);
                        }
                    }
                    if (!IsDataRowNull(AssessmentDr, "openencounter"))
                    {
                        if (AssessmentDr["openencounter"] != System.DBNull.Value)
                        {
                            OpenEncounter = Convert.ToInt32(AssessmentDr["openencounter"].ToString());
                            // Check if the Encounter exist with Encounter.encounterid=OpenEncounter
                            EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                            if (EncounterJMJValueNodeList.Count > 0)
                            {

                                bool ContainsEncounter = false;
                                for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                                {
                                    if (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) == OpenEncounter)
                                    {
                                        ContainsEncounter = true;
                                        // Modify the Encounter node
                                        EncounterDs = GetEncounter(strCprid, OpenEncounter);
                                        EncounterDr = EncounterDs.Tables[0].Rows[0];
                                        EncounterNoteDs = getProgress(strCprid, "Encounter", OpenEncounter, null, null, null);
                                        XmlNode JMJEncounterNode = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter];
                                        if (Convert.ToInt32(JMJEncounterNode.Attributes["EncounterID"].Value) == Convert.ToInt32(EncounterDr["encounterid"].ToString()))
                                        {
                                            UpdateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter],
                                                objJMJXmlActors, objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Encounter"),
                                                objJMJMapperTempActorList, EncounterDr, EncounterNoteDs);
                                            break;
                                        }

                                    }
                                    else if (ContainsEncounter == false && ((iCounter + 1) == EncounterJMJValueNodeList.Count))
                                    {
                                        ProcessEncounterContext(OpenEncounter, strCprid, objJMJXmlDoc, objJMJXmlActors, objMapperTempXmlDoc);
                                    }
                                }
                            }
                            else
                            {
                                ProcessEncounterContext(OpenEncounter, strCprid, objJMJXmlDoc, objJMJXmlActors, objMapperTempXmlDoc);
                            }

                        }

                        if (AssessmentDr["closeencounter"] != System.DBNull.Value)
                        {
                            CloseEncounter = Convert.ToInt32(AssessmentDr["closeencounter"].ToString());
                            // Check if the Encounter exist with Encounter.encounterid=OpenEncounter
                            EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                            if (EncounterJMJValueNodeList.Count > 0)
                            {
                                bool ContainsEncounter = false;
                                for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                                {
                                    if (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) == CloseEncounter)
                                    {
                                        ContainsEncounter = true;
                                        // Modify the Encounter node
                                        EncounterDs = GetEncounter(strCprid, CloseEncounter);
                                        EncounterDr = EncounterDs.Tables[0].Rows[0];
                                        EncounterNoteDs = getProgress(strCprid, "Encounter", CloseEncounter, null, null, null);
                                        XmlNode JMJEncounterNode = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter];
                                        if (Convert.ToInt32(JMJEncounterNode.Attributes["EncounterID"].Value) == Convert.ToInt32(EncounterDr["encounterid"].ToString()))
                                        {
                                            UpdateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter],
                                                objJMJXmlActors, objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Encounter"),
                                                objJMJMapperTempActorList, EncounterDr, EncounterNoteDs);
                                            break;
                                        }
                                    }
                                    else if (ContainsEncounter == false && ((iCounter + 1) == EncounterJMJValueNodeList.Count))
                                    {
                                        ProcessEncounterContext(CloseEncounter, strCprid, objJMJXmlDoc,
                                            objJMJXmlActors, objMapperTempXmlDoc);
                                    }
                                }
                            }
                            else
                            {
                                ProcessEncounterContext(CloseEncounter, strCprid, objJMJXmlDoc,
                                    objJMJXmlActors, objMapperTempXmlDoc);
                            }

                        }
                        // Create Assessment Node
                        bool ContainsAssessment = false;
                        AssessmentJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Assessment/ObjectID/JMJValue");
                        for (int iCounter = 0; iCounter < AssessmentJMJValueNodeList.Count; iCounter++)
                        {

                            if (AssessmentProblemId == Convert.ToInt32(AssessmentJMJValueNodeList[iCounter].InnerText))
                            {
                                ContainsAssessment = true;

                            }
                        }
                        if (!ContainsAssessment)
                        {
                            CreateAssessment(objJMJXmlDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                                objJMJXmlActors, objJMJMapperTempAssessment,
                                objJMJMapperTempActorList, AssessmentDr, AssessmentNoteDs);

                            ProcessAssessmentClinicalContextTreatment(strCprid, "Assessment", objectKey,
                                AssessmentProblemId, objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlActors,
                                objMapperTempXmlDoc);


                        }
                    }

                }
            }
            catch (Exception ex)
            {
                string msg = "Error while creation in Assessment Clinical context";
                throw new Exception(msg, ex);
            }


        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * Modified By: Nitin Vikraman		  Date: 21-08-2007
        * 
        * Purpose: This function is called for the creation of Treatment Nodes
        * ,TreatmentNote and associated Assessment for the Treatment Clinical
        * Context
        * 
        * Description: 
        * This routine returns Treatment Nodes ,TreatmentNote and associated
        * Assessment for the Treatment Clinical Context
        *
        * ********************************************************************/
        private void ProcessTreatmentClinicalContextAssessment(int objectKey, string strCprid,
            XmlDocument objJMJXmlDoc, XmlDocument JMJComponentDataDoc, XmlNode objJMJXmlActors,
            XmlDocument objMapperTempXmlDoc)
        {
            DataSet AssessmentDs = new DataSet();
            DataSet EncounterDs = new DataSet();
            DataSet AssessmentNoteDs = new DataSet();
            DataSet EncounterNoteDs = new DataSet();
            XmlDocument objTreatmentDoc = new XmlDocument();
            XmlNodeList EncounterJMJValueNodeList = null;
            XmlNodeList AssessmentJMJValueNodeList = null;
            XmlNodeList objJMJMapperTempActorList = null;

            DataRow AssessmentDr = null;
            DataRow EncounterDr = null;
            DataSet TreatmentDs = new DataSet();
            DataRow TreatmentDr = null;

            XmlNode objJMJMapperTempAssessment = null;

            int AssessmentProblemId = 0;
            int OpenEncounter = 0;
            int CloseEncounter = 0;
            int TrtLastOrderEncounter = 0;
            try
            {
                AssessmentDs = GetAssessment(strCprid, "Treatment", objectKey);
                if (AssessmentDs.Tables[0].Rows.Count > 0)
                {
                    objJMJMapperTempActorList = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Actors").ChildNodes;
                    objJMJMapperTempAssessment = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Assessment");

                    for (int iAssessmentRowCounter = 0; iAssessmentRowCounter < AssessmentDs.Tables[0].Rows.Count; iAssessmentRowCounter++)
                    {
                        AssessmentDr = AssessmentDs.Tables[0].Rows[iAssessmentRowCounter];
                        if (!IsDataRowNull(AssessmentDr, "problemid"))
                        {
                            if (AssessmentDr["problemid"] != System.DBNull.Value)
                            {
                                AssessmentProblemId = Convert.ToInt32(AssessmentDr["problemid"].ToString());
                                AssessmentNoteDs = getProgress(strCprid, "Assessment", AssessmentProblemId, null, null, null);

                            }
                        }
                        if (!IsDataRowNull(AssessmentDr, "openencounter"))
                        {
                            if (AssessmentDr["openencounter"] != System.DBNull.Value)
                            {
                                OpenEncounter = Convert.ToInt32(AssessmentDr["openencounter"].ToString());
                                // Check if the Encounter exist with Encounter.encounterid=OpenEncounter
                                EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                                if (EncounterJMJValueNodeList.Count > 0)
                                {
                                    bool ContainsEncounter = false;
                                    for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                                    {
                                        if (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) == OpenEncounter)
                                        {
                                            ContainsEncounter = true;
                                            // Modify the Encounter node
                                            EncounterDs = GetEncounter(strCprid, OpenEncounter);
                                            EncounterDr = EncounterDs.Tables[0].Rows[0];
                                            EncounterNoteDs = getProgress(strCprid, "Encounter", OpenEncounter, null, null, null);
                                            XmlNode JMJEncounterNode = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter];
                                            if (Convert.ToInt32(JMJEncounterNode.Attributes["EncounterID"].Value) == Convert.ToInt32(EncounterDr["encounterid"].ToString()))
                                            {
                                                UpdateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter],
                                                    objJMJXmlActors, objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Encounter"),
                                                    objJMJMapperTempActorList, EncounterDr, EncounterNoteDs);
                                                break;
                                            }

                                        }
                                        else if (ContainsEncounter == false && ((iCounter + 1) == EncounterJMJValueNodeList.Count))
                                        {
                                            ProcessEncounterContext(OpenEncounter, strCprid, objJMJXmlDoc,
                                                objJMJXmlActors, objMapperTempXmlDoc);
                                        }
                                    }
                                }
                                else
                                {
                                    ProcessEncounterContext(OpenEncounter, strCprid, objJMJXmlDoc,
                                        objJMJXmlActors, objMapperTempXmlDoc);
                                }
                            }
                            if (AssessmentDr["closeencounter"] != System.DBNull.Value)
                            {
                                CloseEncounter = Convert.ToInt32(AssessmentDr["closeencounter"].ToString());
                                // Check if the Encounter exist with Encounter.encounterid=OpenEncounter
                                EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                                if (EncounterJMJValueNodeList.Count > 0)
                                {
                                    bool ContainsEncounter = false;
                                    for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                                    {
                                        if (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) == CloseEncounter)
                                        {
                                            ContainsEncounter = true;
                                            // Modify the Encounter node
                                            EncounterDs = GetEncounter(strCprid, CloseEncounter);
                                            EncounterDr = EncounterDs.Tables[0].Rows[0];
                                            EncounterNoteDs = getProgress(strCprid, "Encounter", CloseEncounter, null, null, null);
                                            XmlNode JMJEncounterNode = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter];
                                            if (Convert.ToInt32(JMJEncounterNode.Attributes["EncounterID"].Value) == Convert.ToInt32(EncounterDr["encounterid"].ToString()))
                                            {
                                                UpdateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter],
                                                    objJMJXmlActors, objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Encounter"),
                                                    objJMJMapperTempActorList, EncounterDr, EncounterNoteDs);
                                                break;
                                            }

                                        }
                                        else if (ContainsEncounter == false && ((iCounter + 1) == EncounterJMJValueNodeList.Count))
                                        {
                                            ProcessEncounterContext(CloseEncounter, strCprid, objJMJXmlDoc,
                                                objJMJXmlActors, objMapperTempXmlDoc);
                                        }
                                    }
                                }
                                else
                                {
                                    ProcessEncounterContext(CloseEncounter, strCprid, objJMJXmlDoc,
                                        objJMJXmlActors, objMapperTempXmlDoc);
                                }

                            }
                            // Create Assessment Node
                            bool ContainsAssessment = false;
                            AssessmentJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Assessment/ObjectID/JMJValue");
                            for (int iCounter = 0; iCounter < AssessmentJMJValueNodeList.Count; iCounter++)
                            {
                                if (AssessmentProblemId == Convert.ToInt32(AssessmentJMJValueNodeList[iCounter].InnerText))
                                {
                                    ContainsAssessment = true;
                                    // Modify the Assessment Node
                                }
                            }
                            if (!ContainsAssessment)
                            {
                                CreateAssessment(objJMJXmlDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                                    objJMJXmlActors, objJMJMapperTempAssessment,
                                    objJMJMapperTempActorList, AssessmentDr, AssessmentNoteDs);
                            }
                        }
                        ProcessTreatmentClincalContextTreatment(strCprid, "Treatment", objectKey,
                            Convert.ToInt32(AssessmentDr["problemid"].ToString()), objJMJXmlDoc, JMJComponentDataDoc,
                            objJMJXmlActors, objMapperTempXmlDoc);
                    }
                }
                else
                {
                    string TreatmentQuery = "exec dbo.jmjdoc_get_treatment @ps_cpr_id,@ps_context_object,@pl_object_key";
                    TreatmentDs = GetTreatment(TreatmentQuery, strCprid, "Treatment", objectKey, objectKey);
                    TreatmentDr = TreatmentDs.Tables[0].Rows[0];
                    if (!IsDataRowNull(TreatmentDr, "openencounter"))
                    {
                        if (TreatmentDr["openencounter"] != System.DBNull.Value)
                        {
                            OpenEncounter = Convert.ToInt32(TreatmentDr["openencounter"].ToString());
                            // Check if the Encounter exist with Encounter.encounterid=OpenEncounter
                            EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                            if (EncounterJMJValueNodeList.Count > 0)
                            {
                                bool ContainsEncounter = false;
                                for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                                {
                                    if (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) == OpenEncounter)
                                    {
                                        ContainsEncounter = true;
                                        // Modify the Encounter node
                                        EncounterDs = GetEncounter(strCprid, OpenEncounter);
                                        EncounterDr = EncounterDs.Tables[0].Rows[0];
                                        EncounterNoteDs = getProgress(strCprid, "Encounter", OpenEncounter, null, null, null);
                                        XmlNode JMJEncounterNode = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter];
                                        if (Convert.ToInt32(JMJEncounterNode.Attributes["EncounterID"].Value) == Convert.ToInt32(EncounterDr["encounterid"].ToString()))
                                        {
                                            UpdateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter],
                                                objJMJXmlActors, objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Encounter"),
                                                objJMJMapperTempActorList, EncounterDr, EncounterNoteDs);
                                            break;
                                        }

                                    }
                                    else if (ContainsEncounter == false && ((iCounter + 1) == EncounterJMJValueNodeList.Count))
                                    {
                                        ProcessEncounterContext(OpenEncounter, strCprid, objJMJXmlDoc,
                                            objJMJXmlActors, objMapperTempXmlDoc);
                                    }
                                }
                            }
                            else
                            {
                                ProcessEncounterContext(OpenEncounter, strCprid, objJMJXmlDoc,
                                    objJMJXmlActors, objMapperTempXmlDoc);
                            }
                        }
                        // sumathi added to include the last encounter block 3/3/2009
                        if (!IsDataRowNull(TreatmentDr, "last_encounter_id"))
                        {
                            if (TreatmentDr["last_encounter_id"] != System.DBNull.Value)
                            {
                                TrtLastOrderEncounter = Convert.ToInt32(TreatmentDr["last_encounter_id"].ToString());
                                // Check if the Encounter exist with Encounter.encounterid=last ordered encounter
                                EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                                if (EncounterJMJValueNodeList.Count > 0)
                                {
                                    bool ContainsEncounter = false;
                                    for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                                    {
                                        if (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) == TrtLastOrderEncounter)
                                        {
                                            ContainsEncounter = true;
                                            // Modify the Encounter node
                                            EncounterDs = GetEncounter(strCprid, TrtLastOrderEncounter);
                                            EncounterDr = EncounterDs.Tables[0].Rows[0];
                                            EncounterNoteDs = getProgress(strCprid, "Encounter", TrtLastOrderEncounter, null, null, null);
                                            XmlNode JMJEncounterNode = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter];
                                            if (Convert.ToInt32(JMJEncounterNode.Attributes["EncounterID"].Value) == Convert.ToInt32(EncounterDr["encounterid"].ToString()))
                                            {
                                                UpdateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter],
                                                    objJMJXmlActors, objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Encounter"),
                                                    objJMJMapperTempActorList, EncounterDr, EncounterNoteDs);
                                                break;
                                            }

                                        }
                                        else if (ContainsEncounter == false && ((iCounter + 1) == EncounterJMJValueNodeList.Count))
                                        {
                                            ProcessEncounterContext(TrtLastOrderEncounter, strCprid, objJMJXmlDoc,
                                                objJMJXmlActors, objMapperTempXmlDoc);
                                        }
                                    }
                                }
                                else
                                {
                                    ProcessEncounterContext(TrtLastOrderEncounter, strCprid, objJMJXmlDoc,
                                        objJMJXmlActors, objMapperTempXmlDoc);
                                }
                            }
                        }

                        if (TreatmentDr["closeencounter"] != System.DBNull.Value)
                        {
                            CloseEncounter = Convert.ToInt32(TreatmentDr["closeencounter"].ToString());
                            // Check if the Encounter exist with Encounter.encounterid=OpenEncounter
                            EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                            if (EncounterJMJValueNodeList.Count > 0)
                            {
                                bool ContainsEncounter = false;
                                for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                                {
                                    if (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) == CloseEncounter)
                                    {
                                        ContainsEncounter = true;
                                        // Modify the Encounter node
                                        EncounterDs = GetEncounter(strCprid, CloseEncounter);
                                        EncounterDr = EncounterDs.Tables[0].Rows[0];
                                        EncounterNoteDs = getProgress(strCprid, "Encounter", CloseEncounter, null, null, null);
                                        XmlNode JMJEncounterNode = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter];
                                        if (Convert.ToInt32(JMJEncounterNode.Attributes["EncounterID"].Value) == Convert.ToInt32(EncounterDr["encounterid"].ToString()))
                                        {
                                            UpdateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter],
                                                objJMJXmlActors, objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Encounter"),
                                                objJMJMapperTempActorList, EncounterDr, EncounterNoteDs);
                                            break;
                                        }

                                    }
                                    else if (ContainsEncounter == false && ((iCounter + 1) == EncounterJMJValueNodeList.Count))
                                    {
                                        ProcessEncounterContext(CloseEncounter, strCprid, objJMJXmlDoc,
                                            objJMJXmlActors, objMapperTempXmlDoc);
                                    }
                                }
                            }
                            else
                            {
                                ProcessEncounterContext(CloseEncounter, strCprid, objJMJXmlDoc,
                                    objJMJXmlActors, objMapperTempXmlDoc);
                            }

                        }

                    }

                    ProcessTreatmentClincalContextTreatment(strCprid, "Treatment", objectKey,
                        0, objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlActors, objMapperTempXmlDoc);
                }



            }
            catch (Exception ex)
            {
                string msg = "Error while creating Treatment-Assessment Nodes";
                throw new Exception(msg, ex);
            }


        }

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of associated
        * Encounter and Patient Nodes for Patient Clinical Context 
        * 
        * Description: 
        * This routine returns the Encounter nodes associated with the 
        * Patient and the assessments nodes. This function is called when
        * Clinical Context is Patient. 
        *
        * ******************************************************************/

        private void ProcessPatientEncounterContext(string strCprid, XmlDocument objJMJXmlDoc, XmlDocument JMJComponentDataDoc, XmlNode objJMJXmlActors,
            XmlDocument objMapperTempXmlDoc)
        {
            DataSet EncounterDs = new DataSet();
            DataSet EncounterNoteDs = new DataSet();
            int EncounterId = 0;
            int EncounterJMJValue;
            int EncounterIDValue;
            DataRow EncounterDr = null;
            XmlNode objJMJMapperTempEncounter = null;
            XmlNodeList objJMJMapperTempActorList = null;
            XmlNodeList EncounterJMJValueList = null;
            EncounterDs = GetEncounter(strCprid, 0);
            if (EncounterDs != null)
            {
                if (EncounterDs.Tables.Count > 0)
                {
                    if (EncounterDs.Tables[0].Rows.Count > 0)
                    {

                        objJMJMapperTempEncounter = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Encounter");
                        objJMJMapperTempActorList = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Actors").ChildNodes;
                        for (int iEncounterRowCounter = 0; iEncounterRowCounter < EncounterDs.Tables[0].Rows.Count; iEncounterRowCounter++)
                        {
                            EncounterDr = EncounterDs.Tables[0].Rows[iEncounterRowCounter];
                            EncounterId = Convert.ToInt32(EncounterDr["encounterid"].ToString());
                            EncounterJMJValueList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                            EncounterNoteDs = this.getProgress(strCprid, "Encounter", EncounterId, null, null, null);
                            for (int iCounter = 0; iCounter <= EncounterJMJValueList.Count; iCounter++)
                            {
                                if (EncounterJMJValueList[iCounter] != null)
                                {
                                    EncounterJMJValue = Convert.ToInt32(EncounterJMJValueList[iCounter].InnerText);
                                    EncounterIDValue = Convert.ToInt32(EncounterDr["encounterid"].ToString());
                                    if (EncounterIDValue == EncounterJMJValue)
                                    {
                                        break;
                                    }
                                    if ((iCounter == EncounterJMJValueList.Count) &&
                                        (EncounterIDValue != EncounterJMJValue))
                                    {
                                        CreateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                                            objJMJXmlActors, objJMJMapperTempEncounter, objJMJMapperTempActorList, EncounterDr,
                                            EncounterNoteDs, true);
                                        ProcessPatientEncounterAssessmentContext(EncounterId, strCprid, objJMJXmlDoc,
                                            JMJComponentDataDoc, objJMJXmlActors, objMapperTempXmlDoc);
                                    }
                                }
                                else
                                {
                                    CreateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                                        objJMJXmlActors, objJMJMapperTempEncounter, objJMJMapperTempActorList,
                                        EncounterDr, EncounterNoteDs, true);
                                    ProcessPatientEncounterAssessmentContext(EncounterId, strCprid, objJMJXmlDoc,
                                        JMJComponentDataDoc, objJMJXmlActors, objMapperTempXmlDoc);
                                }
                            }
                        }
                    }
                }
            }
        }

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of Encounter Nodes
        * 
        * Description: 
        * This routine returns Encounter Nodes. This rountine is called while
        * the generation of Assesment nodes. This Function also returns Actors.
        *
        * ********************************************************************/
        private void ProcessEncounterContext(int EncounterId, string strCprid, XmlDocument objJMJXmlDoc,
            XmlNode objJMJXmlActors, XmlDocument objMapperTempXmlDoc)
        {
            DataSet EncounterDs = new DataSet();
            DataSet EncounterNoteDs = new DataSet();

            DataRow EncounterDr = null;
            XmlNode objJMJMapperTempEncounter = null;
            XmlNodeList objJMJMapperTempActorList = null;

            EncounterDs = GetEncounter(strCprid, EncounterId);

            if (EncounterDs.Tables[0].Rows.Count > 0)
            {

                EncounterNoteDs = this.getProgress(strCprid, "Encounter", EncounterId, null, null, null);

                objJMJMapperTempEncounter = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Encounter");
                objJMJMapperTempActorList = objMapperTempXmlDoc.SelectSingleNode("//JMJDocument/Actors").ChildNodes;

                for (int iEncounterRowCounter = 0; iEncounterRowCounter < EncounterDs.Tables[0].Rows.Count; iEncounterRowCounter++)
                {
                    EncounterDr = EncounterDs.Tables[0].Rows[iEncounterRowCounter];
                    XmlNodeList EncounterJMJValueList = null;
                    EncounterJMJValueList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");

                    CreateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectSingleNode("//JMJDocument/PatientRecord"),
                        objJMJXmlActors, objJMJMapperTempEncounter, objJMJMapperTempActorList, EncounterDr,
                        EncounterNoteDs, true);
                }
            }

        }

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of Patient Note Node 
        *
        * Description: 
        * This routine returns the Patient Note. This routine is called during
        * the creation of Patient Nodes
        *
        * ******************************************************************/
        private void CreatePatientNote(XmlDocument objJMJXmlDoc, XmlNode objJMJPatientNote,
            XmlNode objXmlMapperPatientNode, DataRow PatientNoteDr)
        {
            XmlNode objJMJPatientNoteChild = null;
            foreach (XmlNode objXmlPatientNoteNode in objXmlMapperPatientNode.ChildNodes)
            {
                if (objXmlPatientNoteNode.NodeType == XmlNodeType.Element)
                {
                    if (!IsDataRowNull(PatientNoteDr, objXmlPatientNoteNode.InnerText))
                    {
                        if (PatientNoteDr[objXmlPatientNoteNode.InnerText] != System.DBNull.Value)
                        {
                            objJMJPatientNoteChild = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlPatientNoteNode.Name, null);
                            objJMJPatientNote.AppendChild(objJMJPatientNoteChild);
                            objJMJPatientNoteChild.InnerText = PatientNoteDr[objXmlPatientNoteNode.InnerText].ToString();
                        }
                    }
                }
            }
        }

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of Patient Nodes 
        * and Patient Note
        * 
        * Description: 
        * This routine returns the Patient infomation like Patient details 
        * along with the Patient Node. This function is called before the 
        * processing of any clinical context. This routine is recurisively 
        * called. 
        * ******************************************************************/

        private void CreatePatient(XmlDocument objJMJXmlDoc, XmlNode objJMJXml,
            XmlNode objJMJMapperTempPatient, DataSet PatientDs, DataSet PatientNoteDs)
        {
            try
            {
                XmlNode objJMJXmlPatient = null;
                objJMJXmlPatient = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objJMJMapperTempPatient.Name, null);
                objJMJXml.AppendChild(objJMJXmlPatient);


                if (objJMJMapperTempPatient.ChildNodes.Count > 0 &&
                    objJMJMapperTempPatient.NodeType == XmlNodeType.Element)
                {
                    foreach (XmlNode objXmlPatientNode in objJMJMapperTempPatient.ChildNodes)
                    {
                        if (objXmlPatientNode.NodeType == XmlNodeType.Element &&
                            objXmlPatientNode.Name == "PatientNote")
                        {
                            DataRow PatientNoteDr = null;

                            for (int iPatientNote = 0; iPatientNote < PatientNoteDs.Tables[0].Rows.Count; iPatientNote++)
                            {
                                PatientNoteDr = PatientNoteDs.Tables[0].Rows[iPatientNote];
                                XmlNode objJMJPatientNote = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlPatientNode.Name, null);
                                objJMJXmlPatient.AppendChild(objJMJPatientNote);
                                CreatePatientNote(objJMJXmlDoc, objJMJPatientNote,
                                    objXmlPatientNode, PatientNoteDr);
                            }
                        }
                        else if (objXmlPatientNode.NodeType == XmlNodeType.Element)
                        {
                            CreatePatient(objJMJXmlDoc, objJMJXmlPatient, objXmlPatientNode, PatientDs, PatientNoteDs);
                        }
                        else if (objXmlPatientNode.NodeType == XmlNodeType.Text
                            && objXmlPatientNode.Name == "#text")
                        {
                            DataRow dr = PatientDs.Tables[0].Rows[0];
                            if (!IsDataRowNull(dr, objXmlPatientNode.InnerText))
                            {
                                // Condition to check Check for null values in the datarow
                                // If condition true , then set the node text
                                if (dr[objXmlPatientNode.InnerText] != System.DBNull.Value)
                                {
                                    if (objJMJMapperTempPatient.Name == "StartDate" ||
                                        objJMJMapperTempPatient.Name == "TerminationDate")
                                    {
                                        objJMJXmlPatient.InnerText = Convert.ToDateTime(dr[objXmlPatientNode.InnerText]
                                            .ToString()).ToString("u");

                                    }
                                    else
                                    {
                                        objJMJXmlPatient.InnerText = dr[objXmlPatientNode.InnerText].ToString();
                                    }
                                }
                                // If the condition false, then remove the node
                                else
                                {
                                    objJMJXml.RemoveChild(objJMJXmlPatient);
                                }
                            }
                            else
                            {
                                objJMJXml.RemoveChild(objJMJXmlPatient);
                            }


                        }
                    }
                }
                else if (objJMJMapperTempPatient.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempPatient.Attributes.Count > 0)
                    {
                        if (objJMJMapperTempPatient.Attributes["default"] != null)
                        {
                            if (objJMJMapperTempPatient.Attributes["default"].Value != "")
                            {
                                objJMJXmlPatient.InnerText = objJMJMapperTempPatient.
                                    Attributes["default"].Value;

                            }
                        }

                    }
                    else if (objJMJMapperTempPatient.InnerText == "" && !objJMJMapperTempPatient.HasChildNodes)
                    {
                        objJMJXml.RemoveChild(objJMJXmlPatient);
                    }

                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error while creation of Patient Nodes", ex);
            }

        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * Modified By: Nitin Vikraman		  Date: 20-08-2007
        * 
        * Purpose: This function is called for the creation of Encounter Child 
        * Nodes and Encounter Note
        * 
        * Description: 
        * This routine create Encounter Child Notes along with the Encounter 
        * Note
        *
        * ******************************************************************/
        private void CreateEncounterChildNodes(XmlDocument objJMJXmlDoc, XmlNode objJMJXmlPatient,
            XmlNode objJMJXmlActors, XmlNode objJMJMapperTempEncounter, XmlNodeList objJMJMapperTempActorList,
            DataRow EncounterDr, DataSet EncounterNoteDs, XmlNode objJMJXmlEncounter, bool IsEncounterContext)
        {

            foreach (XmlNode objXmlEncounterNode in objJMJMapperTempEncounter.ChildNodes)
            {
                if (objXmlEncounterNode.NodeType == XmlNodeType.Element)
                {
                    // Condition for restricting the creation of nodes when the primary 
                    // clinical context is not Encounter
                    if ((IsEncounterContext == false) &&
                        (objXmlEncounterNode.Name == "EncounterLocation" ||
                        objXmlEncounterNode.Name == "WorkersCompFlag" ||
                        objXmlEncounterNode.Name == "InpatientStatus" ||
                        objXmlEncounterNode.Name == "OutpatientStatus" ||
                        objXmlEncounterNode.Name == "IndirectEncounterStatus" ||
                        objXmlEncounterNode.Name == "OtherEncounterStatus" ||
                        objXmlEncounterNode.Name == "EncounterNote"))
                    {
                        continue;
                    }
                    else if (objXmlEncounterNode.Name == "EncounterNote")
                    {
                        DataRow EncounterNoteDr = null;
                        for (int iEncounterNote = 0; iEncounterNote < EncounterNoteDs.Tables[0].Rows.Count; iEncounterNote++)
                        {
                            EncounterNoteDr = EncounterNoteDs.Tables[0].Rows[iEncounterNote];
                            XmlNode objJMJEncounterNote = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlEncounterNode.Name, null);
                            objJMJXmlEncounter.AppendChild(objJMJEncounterNote);
                            CreateEncounterNote(objJMJXmlDoc, objJMJEncounterNote, objXmlEncounterNode, EncounterNoteDr);
                        }
                    }
                    else
                        CreateEncounter(objJMJXmlDoc, objJMJXmlEncounter, objJMJXmlActors, objXmlEncounterNode,
                            objJMJMapperTempActorList, EncounterDr, EncounterNoteDs, IsEncounterContext);
                }
                else if (objXmlEncounterNode.NodeType == XmlNodeType.Text
                    && objXmlEncounterNode.Name == "#text")
                {
                    //dr=EncounterDs.Tables[0].Rows[0];
                    bool ContainsFlag = false;
                    if (!IsDataRowNull(EncounterDr, objXmlEncounterNode.InnerText))
                    {
                        // Condition to check Check for null values in the datarow
                        // If condition true , then set the node text
                        if (EncounterDr[objXmlEncounterNode.InnerText] != System.DBNull.Value)
                        {

                            if (objJMJMapperTempEncounter.Name == "EncounterDate" ||
                                objJMJMapperTempEncounter.Name == "EncounterEndDate" ||
                                objJMJMapperTempEncounter.Name == "DischargeDate" ||
                                objJMJMapperTempEncounter.Name == "EncounterEndDate")
                            {
                                objJMJXmlEncounter.InnerText = Convert.ToDateTime(EncounterDr[objXmlEncounterNode.InnerText]
                                    .ToString()).ToString("u");
                            }
                            else if (objJMJMapperTempEncounter.Name == "NewPatient")
                            {
                                if (EncounterDr[objJMJMapperTempEncounter.InnerText].ToString() == "N")
                                {
                                    objJMJXmlEncounter.InnerText = "New";
                                }
                                else
                                {
                                    objJMJXmlEncounter.InnerText = "Established";
                                }

                            }
                            else if (objJMJMapperTempEncounter.Name == "AttendingDoctor")
                            {

                                objJMJXmlEncounter.InnerText = EncounterDr[objXmlEncounterNode.InnerText].ToString();
                                // Code for creation of Actor Nodes
                                XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                int jCounter = 0;
                                for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                {
                                    if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJXmlEncounter.InnerText)
                                    {
                                        ContainsFlag = true;
                                        break;
                                    }
                                }
                                if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                {
                                    for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                    {
                                        if (objJMJMapperTempActorList[iCounter].Name == "ActorAttendingDoctor")
                                        {
                                            CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                EncounterDr);
                                        }
                                    }
                                }
                            }
                            else if (objJMJMapperTempEncounter.Name == "ReferringDoctor")
                            {
                                objJMJXmlEncounter.InnerText = EncounterDr[objXmlEncounterNode.InnerText].ToString();
                                // Code for creation of Actor Nodes
                                XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                int jCounter = 0;
                                for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                {
                                    if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJXmlEncounter.InnerText)
                                    {
                                        ContainsFlag = true;
                                        break;
                                    }
                                }
                                if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                {
                                    for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                    {
                                        if (objJMJMapperTempActorList[iCounter].Name == "ActorReferringDoctor")
                                        {
                                            CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                EncounterDr);
                                        }
                                    }
                                }
                            }
                            else if (objJMJMapperTempEncounter.Name == "SupervisingDoctor")
                            {
                                objJMJXmlEncounter.InnerText = EncounterDr[objXmlEncounterNode.InnerText].ToString();
                                // Code for creation of Actor Nodes
                                XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                int jCounter = 0;
                                for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                {
                                    if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJXmlEncounter.InnerText)
                                    {
                                        ContainsFlag = true;
                                        break;
                                    }
                                }
                                if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                {
                                    for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                    {
                                        if (objJMJMapperTempActorList[iCounter].Name == "ActorSupervisingDoctor")
                                        {
                                            CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                EncounterDr);
                                        }
                                    }
                                }
                            }
                            else if (objJMJMapperTempEncounter.Name == "EncounterLocation")
                            {
                                objJMJXmlEncounter.InnerText = EncounterDr[objXmlEncounterNode.InnerText].ToString();
                                // Code for creation of Actor Nodes
                                XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                int jCounter = 0;
                                for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                {
                                    if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJXmlEncounter.InnerText)
                                    {
                                        ContainsFlag = true;
                                        break;
                                    }
                                }
                                if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                {
                                    for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                    {
                                        if (objJMJMapperTempActorList[iCounter].Name == "ActorEncounterLocation")
                                        {
                                            CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                EncounterDr);
                                        }
                                    }
                                }
                            }
                            else
                            {
                                objJMJXmlEncounter.InnerText = EncounterDr[objXmlEncounterNode.InnerText].ToString();
                            }
                        }
                        // If the condition false, then remove the node
                        else
                        {
                            objJMJXmlPatient.RemoveChild(objJMJXmlEncounter);
                        }
                    }
                    else
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlEncounter);
                    }

                }
            }

        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of Actor Child Nodes
        * for the Encounters and the Treatment Nodes
        * 
        * Description: 
        * This routine returns Actor Child Nodes
        *
        * ********************************************************************/
        private void CreateActorChildNodes(XmlDocument objJMJXmlDoc, XmlNode objJMJXmlActors,
            XmlNode objJMJXmlActor,
            XmlNode objJMJMapperTempActor, DataRow GenericActorDr)
        {

            if (objJMJMapperTempActor.ChildNodes.Count > 0 &&
                objJMJMapperTempActor.NodeType == XmlNodeType.Element)
            {
                if (objJMJMapperTempActor.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempActor.Attributes.Count > 0)
                    {
                        if (objJMJMapperTempActor.Attributes["default"] != null)
                        {
                            if (objJMJMapperTempActor.Attributes["default"].Value != "")
                            {
                                objJMJXmlActor.InnerText = objJMJMapperTempActor.
                                    Attributes["default"].Value;
                            }
                        }
                    }
                }
                foreach (XmlNode objXmlActorNode in objJMJMapperTempActor.ChildNodes)
                {
                    if (objXmlActorNode.NodeType == XmlNodeType.Element)
                    {
                        CreateActorNode(objJMJXmlDoc, objJMJXmlActor, objXmlActorNode, GenericActorDr);
                    }
                    else if (objXmlActorNode.NodeType == XmlNodeType.Text
                        && objXmlActorNode.Name == "#text")
                    {
                        if (!IsDataRowNull(GenericActorDr, objXmlActorNode.InnerText))
                        {
                            // Condition to check Check for null values in the datarow
                            // If condition true , then set the node text
                            if (GenericActorDr[objXmlActorNode.InnerText] != System.DBNull.Value)
                            {
                                objJMJXmlActor.InnerText = GenericActorDr[objXmlActorNode.InnerText].ToString();
                            }
                            else
                            {
                                objJMJXmlActors.RemoveChild(objJMJXmlActor);
                            }
                        }
                        else
                        {
                            objJMJXmlActors.RemoveChild(objJMJXmlActor);
                        }
                    }
                }
            }
            else if (objJMJMapperTempActor.NodeType == XmlNodeType.Element)
            {
                if (objJMJMapperTempActor.Attributes.Count > 0)
                {
                    if (objJMJMapperTempActor.Attributes["default"] != null)
                    {
                        if (objJMJMapperTempActor.Attributes["default"].Value != "")
                        {
                            objJMJXmlActor.InnerText = objJMJMapperTempActor.
                                Attributes["default"].Value;
                        }
                    }
                }
                else if (objJMJMapperTempActor.InnerText == "" && !objJMJMapperTempActor.HasChildNodes)
                {
                    objJMJXmlActors.RemoveChild(objJMJXmlActor);
                }

            }
        }

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of Actor Nodes
        * 
        * Description: 
        * This routine returns inner Actor Nodes
        *
        * ********************************************************************/

        private void CreateActorNode(XmlDocument objJMJXmlDoc, XmlNode objJMJXmlActor,
            XmlNode objJMJMapperTempActor, DataRow GenericActorDr)
        {
            XmlNode objJMJXmlActorNode = null;
            objJMJXmlActorNode = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objJMJMapperTempActor.Name, null);
            objJMJXmlActor.AppendChild(objJMJXmlActorNode);
            if (objJMJMapperTempActor.ChildNodes.Count > 0 &&
                objJMJMapperTempActor.NodeType == XmlNodeType.Element)
            {
                CreateActorChildNodes(objJMJXmlDoc, objJMJXmlActor, objJMJXmlActorNode,
                    objJMJMapperTempActor, GenericActorDr);
                if (objJMJMapperTempActor.Name == "ObjectID")
                {
                    if (objJMJXmlActorNode.SelectSingleNode("//JMJDomain") != null)
                    {
                        string strdomain = objJMJXmlActorNode.Clone().SelectSingleNode("//JMJDomain").InnerText;
                        if (strdomain == "user_id" || strdomain == "office_id")
                        {
                            string strvalue = objJMJXmlActorNode.Clone().SelectSingleNode("//JMJValue").InnerText;
                            if (strvalue != "")
                            {
                                DataSet AltUserDs = null;
                                if (strdomain == "user_id")
                                    AltUserDs = GetAltUserProgress(strvalue);
                                else
                                    AltUserDs = GetAltOfficeProgress(strvalue);
                                DataRow dr = null;
                                XmlNode ObjectIdNode = null;
                                XmlNode IDDomainNode = null;
                                XmlNode IDValueNode = null;
                                XmlNode IDOwnerNode = null;
                                string strIDOwner = "", strIDDomain = "", strIDValue = "";

                                for (int i = 0; i < AltUserDs.Tables[0].Rows.Count; i++)
                                {
                                    dr = AltUserDs.Tables[0].Rows[i];
                                    strIDOwner = dr["OwnerID"].ToString();
                                    strIDDomain = dr["IDDomain"].ToString();
                                    strIDValue = dr["IDValue"].ToString();

                                    ObjectIdNode = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "ObjectID", null);
                                    objJMJXmlActor.AppendChild(ObjectIdNode);

                                    IDOwnerNode = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "OwnerID", null);
                                    ObjectIdNode.AppendChild(IDOwnerNode);
                                    IDOwnerNode.InnerText = strIDOwner;

                                    IDDomainNode = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "IDDomain", null);
                                    ObjectIdNode.AppendChild(IDDomainNode);
                                    IDDomainNode.InnerText = strIDDomain;

                                    IDValueNode = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "IDValue", null);
                                    ObjectIdNode.AppendChild(IDValueNode);
                                    IDValueNode.InnerText = strIDValue;
                                }
                            }
                        }
                    }
                }

            }
            else if (objJMJMapperTempActor.NodeType == XmlNodeType.Element)
            {
                if (objJMJMapperTempActor.Attributes.Count > 0)
                {
                    if (objJMJMapperTempActor.Attributes["default"] != null)
                    {
                        if (objJMJMapperTempActor.Attributes["default"].Value != "")
                        {
                            objJMJXmlActorNode.InnerText = objJMJMapperTempActor.
                                Attributes["default"].Value;
                        }
                    }
                }
                else if (objJMJMapperTempActor.InnerText == "" && !objJMJMapperTempActor.HasChildNodes)
                {
                    objJMJXmlActor.RemoveChild(objJMJXmlActorNode);
                }

            }

        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of Actor Nodes
        * for the Encounters and the Treatment Nodes
        * 
        * Description: 
        * This routine returns Actor Nodes
        *
        * ********************************************************************/
        private void CreateActor(XmlDocument objJMJXmlDoc, XmlNode objJMJXmlActors,
            XmlNode objJMJMapperTempActor, DataRow GenericActorDr)
        {
            XmlNode objJMJXmlActor = null;
            objJMJXmlActor = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "Actor", null);
            objJMJXmlActors.AppendChild(objJMJXmlActor);
            if (objJMJMapperTempActor.Attributes.Count > 0)
            {
                if (objJMJMapperTempActor.Attributes["ActorID"] != null)
                {
                    if (objJMJMapperTempActor.Attributes["ActorID"].Value != "")
                    {
                        if (!IsDataRowNull(GenericActorDr, objJMJMapperTempActor.Attributes["ActorID"].Value))
                        {
                            // Condition for creating Patient Status nodes
                            if (GenericActorDr[objJMJMapperTempActor.Attributes["ActorID"].Value] != System.DBNull.Value)
                            {
                                XmlAttribute objActorAttrib = objJMJXmlDoc.CreateAttribute("ActorID");
                                objActorAttrib.Value = GenericActorDr[objJMJMapperTempActor.Attributes["ActorID"].Value].ToString();
                                objJMJXmlActor.Attributes.Append(objActorAttrib);
                                CreateActorChildNodes(objJMJXmlDoc, objJMJXmlActors, objJMJXmlActor,
                                    objJMJMapperTempActor, GenericActorDr);
                            }
                        }
                    }
                }

            }
            if (objJMJXmlActor.NodeType == XmlNodeType.Element)
            {
                if (objJMJXmlActor.InnerText == "" && !objJMJXmlActor.HasChildNodes)
                {
                    objJMJXmlActors.RemoveChild(objJMJXmlActor);
                }

            }
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation  Nodes and 
        * Encounter Note nodes
        * 
        * Description: 
        * This routine returns Encounter Note Nodes. This routine is called 
        * from CreateEncounterChildNodes routine
        *
        * ******************************************************************/
        private void CreateEncounterNote(XmlDocument objJMJXmlDoc, XmlNode objJMJEncounterNote,
            XmlNode objJMJMapperTempEncounterNote, DataRow EncounterNoteDr)
        {
            XmlNode objJMJEncounterNoteChild = null;
            foreach (XmlNode objXmlEncounterNoteNode in objJMJMapperTempEncounterNote.ChildNodes)
            {
                if (objXmlEncounterNoteNode.NodeType == XmlNodeType.Element)
                {
                    if (!IsDataRowNull(EncounterNoteDr, objXmlEncounterNoteNode.InnerText))
                    {
                        if (EncounterNoteDr[objXmlEncounterNoteNode.InnerText] != System.DBNull.Value)
                        {
                            objJMJEncounterNoteChild = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlEncounterNoteNode.Name, null);
                            objJMJEncounterNote.AppendChild(objJMJEncounterNoteChild);
                            objJMJEncounterNoteChild.InnerText = EncounterNoteDr[objXmlEncounterNoteNode.InnerText].ToString();
                        }
                    }
                }
            }
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of Encounter Nodes
        * and the Encounte Note Nodes
        * 
        * Description: 
        * This routine returns the Encounter nodes. This is routine is   
        * recursive.
        *
        * ******************************************************************/
        private void CreateEncounter(XmlDocument objJMJXmlDoc, XmlNode objJMJXmlPatient, XmlNode objJMJXmlActors,
            XmlNode objJMJMapperTempEncounter, XmlNodeList objJMJMapperTempActorList, DataRow EncounterDr,
            DataSet EncounterNoteDs, bool IsEncounterContext)
        {
            try
            {
                XmlNode objJMJXmlEncounter = null;
                objJMJXmlEncounter = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objJMJMapperTempEncounter.Name, null);
                objJMJXmlPatient.AppendChild(objJMJXmlEncounter);


                if (objJMJMapperTempEncounter.ChildNodes.Count > 0 &&
                    objJMJMapperTempEncounter.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempEncounter.Attributes.Count > 0)
                    {
                        if (objJMJMapperTempEncounter.Attributes["EncounterID"] != null)
                        {
                            if (objJMJMapperTempEncounter.Attributes["EncounterID"].Value != "")
                            {
                                XmlAttribute objEncounterAttrib = objJMJXmlDoc.CreateAttribute("EncounterID");
                                objEncounterAttrib.Value = EncounterDr[objJMJMapperTempEncounter.Attributes["EncounterID"].Value].ToString();
                                objJMJXmlEncounter.Attributes.Append(objEncounterAttrib);

                            }
                        }

                    }
                    if (objJMJXmlEncounter.Name == "InpatientStatus" ||
                        objJMJXmlEncounter.Name == "OutpatientStatus" ||
                        objJMJXmlEncounter.Name == "IndirectEncounterStatus" ||
                        objJMJXmlEncounter.Name == "OtherEncounterStatus")
                    {
                        if (!IsDataRowNull(EncounterDr, "encountermode"))
                        {
                            // Condition for creating Patient Status nodes
                            if (EncounterDr["encountermode"] != System.DBNull.Value)
                            {
                                if (objJMJXmlEncounter.Name == "InpatientStatus")
                                {
                                    if (EncounterDr["encountermode"].ToString() == "H")
                                    {
                                        CreateEncounterChildNodes(objJMJXmlDoc, objJMJXmlPatient, objJMJXmlActors,
                                            objJMJMapperTempEncounter, objJMJMapperTempActorList, EncounterDr, EncounterNoteDs, objJMJXmlEncounter, IsEncounterContext);

                                    }
                                    else
                                    {
                                        objJMJXmlPatient.RemoveChild(objJMJXmlEncounter);
                                    }
                                }
                                else if (objJMJXmlEncounter.Name == "OutpatientStatus")
                                {
                                    if (EncounterDr["encountermode"].ToString() == "D")
                                    {
                                        CreateEncounterChildNodes(objJMJXmlDoc, objJMJXmlPatient, objJMJXmlActors, objJMJMapperTempEncounter,
                                            objJMJMapperTempActorList, EncounterDr, EncounterNoteDs, objJMJXmlEncounter, IsEncounterContext);

                                    }
                                    else
                                    {
                                        objJMJXmlPatient.RemoveChild(objJMJXmlEncounter);
                                    }
                                }
                                else if (objJMJXmlEncounter.Name == "IndirectEncounterStatus")
                                {
                                    if (EncounterDr["encountermode"].ToString() == "I")
                                    {
                                        CreateEncounterChildNodes(objJMJXmlDoc, objJMJXmlPatient, objJMJXmlActors, objJMJMapperTempEncounter,
                                            objJMJMapperTempActorList, EncounterDr, EncounterNoteDs, objJMJXmlEncounter, IsEncounterContext);

                                    }
                                    else
                                    {
                                        objJMJXmlPatient.RemoveChild(objJMJXmlEncounter);
                                    }
                                }
                                else if (objJMJXmlEncounter.Name == "OtherEncounterStatus")
                                {
                                    if (EncounterDr["encountermode"].ToString() != "H" && EncounterDr["encountermode"].ToString() != "I" &&
                                        EncounterDr["encountermode"].ToString() != "D")
                                    {
                                        CreateEncounterChildNodes(objJMJXmlDoc, objJMJXmlPatient, objJMJXmlActors, objJMJMapperTempEncounter,
                                            objJMJMapperTempActorList, EncounterDr, EncounterNoteDs, objJMJXmlEncounter, IsEncounterContext);

                                    }
                                    else
                                    {
                                        objJMJXmlPatient.RemoveChild(objJMJXmlEncounter);
                                    }
                                }
                            }
                        }
                        else
                        {
                            objJMJXmlPatient.RemoveChild(objJMJXmlEncounter);
                        }
                    }
                    else
                    {
                        CreateEncounterChildNodes(objJMJXmlDoc, objJMJXmlPatient, objJMJXmlActors,
                            objJMJMapperTempEncounter, objJMJMapperTempActorList, EncounterDr,
                            EncounterNoteDs, objJMJXmlEncounter, IsEncounterContext);

                    }
                }
                else if (objJMJMapperTempEncounter.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempEncounter.Attributes.Count > 0)
                    {
                        if (objJMJMapperTempEncounter.Attributes["default"] != null)
                        {
                            if (objJMJMapperTempEncounter.Attributes["default"].Value != "")
                            {
                                objJMJXmlEncounter.InnerText = objJMJMapperTempEncounter.
                                    Attributes["default"].Value;
                            }
                        }


                    }
                    else if (objJMJMapperTempEncounter.InnerText == "" && !objJMJMapperTempEncounter.HasChildNodes)
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlEncounter);
                    }

                }
                else if (objJMJMapperTempEncounter.NodeType == XmlNodeType.Element)
                {

                    if (objJMJMapperTempEncounter.InnerText == "" && !objJMJMapperTempEncounter.HasChildNodes)
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlEncounter);
                    }

                }
            }
            catch (Exception ex)
            {

                throw new Exception("Error in Encounter Nodes creation", ex);
            }
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of Assessment
        * Note Nodes 
        * 
        * Description: 
        * This routine returns Assessment Note Nodes.
        *
        * ********************************************************************/
        private void CreateAssessmentNote(XmlDocument objJMJXmlDoc, XmlNode objJMJAssessmentNote,
            XmlNode objJMJMapperTempAssessmentNote, DataRow AssessmentNoteDr)
        {
            XmlNode objJMJAssessmentNoteChild = null;
            foreach (XmlNode objXmlAssessmentNoteNode in objJMJMapperTempAssessmentNote.ChildNodes)
            {
                if (objXmlAssessmentNoteNode.NodeType == XmlNodeType.Element)
                {
                    if (!IsDataRowNull(AssessmentNoteDr, objXmlAssessmentNoteNode.InnerText))
                    {
                        if (AssessmentNoteDr[objXmlAssessmentNoteNode.InnerText] != System.DBNull.Value)
                        {
                            objJMJAssessmentNoteChild = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlAssessmentNoteNode.Name, null);
                            objJMJAssessmentNote.AppendChild(objJMJAssessmentNoteChild);
                            objJMJAssessmentNoteChild.InnerText = AssessmentNoteDr[objXmlAssessmentNoteNode.InnerText].ToString();
                        }
                    }
                }
            }
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of Assessment
        * Nodes 
        * 
        * Description: 
        * This routine returns Assessment Nodes. This routine is recursive
        *
        * ********************************************************************/
        private void CreateAssessment(XmlDocument objJMJXmlDoc, XmlNode objJMJXmlPatient, XmlNode objJMJXmlActors,
            XmlNode objJMJMapperTempAssessment, XmlNodeList objJMJMapperTempActorList,
            DataRow AssessmentDr, DataSet AssessmentNoteDs)
        {
            try
            {
                XmlNode objJMJXmlAssessment = null;
                objJMJXmlAssessment = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objJMJMapperTempAssessment.Name, null);
                objJMJXmlPatient.AppendChild(objJMJXmlAssessment);


                if (objJMJMapperTempAssessment.ChildNodes.Count > 0 &&
                    objJMJMapperTempAssessment.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempAssessment.Attributes.Count > 0)
                    {
                        if (objJMJMapperTempAssessment.Attributes["AssessmentID"] != null)
                        {
                            if (objJMJMapperTempAssessment.Attributes["AssessmentID"].Value != "")
                            {
                                XmlAttribute objAssessmentAttrib = objJMJXmlDoc.CreateAttribute("AssessmentID");
                                objAssessmentAttrib.Value = AssessmentDr[objJMJMapperTempAssessment.Attributes["AssessmentID"].Value].ToString();
                                objJMJXmlAssessment.Attributes.Append(objAssessmentAttrib);

                            }
                        }
                    }

                    foreach (XmlNode objXmlAssessmentNode in objJMJMapperTempAssessment.ChildNodes)
                    {
                        if (objXmlAssessmentNode.NodeType == XmlNodeType.Element)
                        {
                            if (objXmlAssessmentNode.Name == "AssessmentNote")
                            {
                                DataRow AssessmentNoteDr = null;
                                for (int iAssessmentNote = 0; iAssessmentNote < AssessmentNoteDs.Tables[0].Rows.Count; iAssessmentNote++)
                                {
                                    AssessmentNoteDr = AssessmentNoteDs.Tables[0].Rows[iAssessmentNote];
                                    XmlNode objJMJAssessmentNote = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlAssessmentNode.Name, null);
                                    objJMJXmlAssessment.AppendChild(objJMJAssessmentNote);
                                    CreateAssessmentNote(objJMJXmlDoc, objJMJAssessmentNote,
                                        objXmlAssessmentNode, AssessmentNoteDr);

                                }
                            }
                            else
                            {
                                CreateAssessment(objJMJXmlDoc, objJMJXmlAssessment, objJMJXmlActors,
                                    objXmlAssessmentNode, objJMJMapperTempActorList,
                                    AssessmentDr, AssessmentNoteDs);
                            }
                        }
                        else if (objXmlAssessmentNode.NodeType == XmlNodeType.Text
                            && objXmlAssessmentNode.Name == "#text")
                        {

                            if (!IsDataRowNull(AssessmentDr, objXmlAssessmentNode.InnerText))
                            {
                                // Condition to check Check for null values in the datarow
                                // If condition true , then set the node text
                                if (AssessmentDr[objXmlAssessmentNode.InnerText] != System.DBNull.Value)
                                {
                                    if (objJMJMapperTempAssessment.Name == "BeginDate")
                                    {
                                        objJMJXmlAssessment.InnerText = Convert.ToDateTime(AssessmentDr[objXmlAssessmentNode.InnerText]
                                            .ToString()).ToString("u");
                                    }
                                    else
                                    {
                                        bool ContainsFlag = false;
                                        objJMJXmlAssessment.InnerText = AssessmentDr[objXmlAssessmentNode.InnerText].ToString();
                                        if (objJMJMapperTempAssessment.Name == "DiagnosedBy")
                                        {

                                            // Code for creation of Actor Nodes
                                            XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                            int jCounter = 0;
                                            for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                            {

                                                if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJXmlAssessment.InnerText)
                                                {
                                                    ContainsFlag = true;
                                                    break;
                                                }
                                            }
                                            if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                            {
                                                for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                                {
                                                    if (objJMJMapperTempActorList[iCounter].Name == "ActorDiagnosedBy")
                                                    {
                                                        CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                            AssessmentDr);
                                                    }
                                                }
                                            }
                                        }
                                    }

                                }
                                // If the condition false, then remove the node
                                else
                                {
                                    objJMJXmlPatient.RemoveChild(objJMJXmlAssessment);
                                }
                            }

                        }
                    }
                }
                else if (objJMJMapperTempAssessment.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempAssessment.Attributes.Count > 0)
                    {
                        if (objJMJMapperTempAssessment.Attributes["default"] != null)
                        {
                            if (objJMJMapperTempAssessment.Attributes["default"].Value != "")
                            {
                                objJMJXmlAssessment.InnerText = objJMJMapperTempAssessment.
                                    Attributes["default"].Value;

                            }
                        }

                    }
                    else if (objJMJMapperTempAssessment.InnerText == "" && !objJMJMapperTempAssessment.HasChildNodes)
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlAssessment);
                    }

                }
                else if (objJMJMapperTempAssessment.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempAssessment.InnerText == "" && !objJMJMapperTempAssessment.HasChildNodes)
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlAssessment);
                    }

                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error in Assessment Nodes creation", ex);
            }

        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called getting Assessment information
        * 
        * Description: 
        * This routine returns DataSet which contains Assessment Info
        *
        * ********************************************************************/
        private DataSet GetAssessment(string strCprid, string context_object, int objectKey)
        {


            System.Data.SqlClient.SqlParameter[] AssessmentDsParams = new System.Data.SqlClient.SqlParameter[3];
            AssessmentDsParams[0] = new SqlParameter("@ps_cpr_id", SqlDbType.VarChar);
            AssessmentDsParams[0].Value = strCprid;
            AssessmentDsParams[1] = new SqlParameter("@ps_context_object", SqlDbType.VarChar);  //"Assessment";
            AssessmentDsParams[1].Value = context_object;
            AssessmentDsParams[2] = new SqlParameter("@pl_object_key", SqlDbType.Int);
            AssessmentDsParams[2].Value = objectKey;
            return base.ExecuteSql("exec dbo.jmjdoc_get_assessment @ps_cpr_id,@ps_context_object,@pl_object_key", ref AssessmentDsParams);

        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called getting Encounter information
        * 
        * Description: 
        * This routine returns DataSet which contains Encounter Info
        *
        * ********************************************************************/

        private DataSet GetEncounter(string strCprid, int EncounterId)
        {
            if (EncounterId == 0)
            {
                System.Data.SqlClient.SqlParameter[] EncounterDsParams = new System.Data.SqlClient.SqlParameter[1];
                EncounterDsParams[0] = new SqlParameter("@ps_cpr_id", SqlDbType.VarChar);
                EncounterDsParams[0].Value = strCprid;
                return base.ExecuteSql("exec dbo.jmjdoc_get_encounter @ps_cpr_id", ref EncounterDsParams);
            }
            else
            {
                System.Data.SqlClient.SqlParameter[] EncounterDsParams = new System.Data.SqlClient.SqlParameter[2];
                EncounterDsParams[0] = new SqlParameter("@ps_cpr_id", SqlDbType.VarChar);
                EncounterDsParams[0].Value = strCprid;
                EncounterDsParams[1] = new SqlParameter("@pl_encounter_id", SqlDbType.Int);
                EncounterDsParams[1].Value = EncounterId;
                return base.ExecuteSql("exec dbo.jmjdoc_get_encounter @ps_cpr_id,@pl_encounter_id", ref EncounterDsParams);
            }


        }

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 17-12-2007
        * 
        * Purpose: This function is called getting charge information
        * 
        * Description: 
        * This routine returns DataSet which contains charge Info
        *
        * ********************************************************************/

        private DataSet GetCharges(string strCprid, int EncounterId)
        {

            System.Data.SqlClient.SqlParameter[] ChargeDsParams = new System.Data.SqlClient.SqlParameter[2];
            ChargeDsParams[0] = new SqlParameter("@ps_cpr_id", SqlDbType.VarChar);
            ChargeDsParams[0].Value = strCprid;
            ChargeDsParams[1] = new SqlParameter("@pl_encounter_id", SqlDbType.Int);
            ChargeDsParams[1].Value = EncounterId;
            return base.ExecuteSql("exec dbo.jmjdoc_get_encounter_charges @ps_cpr_id,@pl_encounter_id", ref ChargeDsParams);

        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 17-12-2007
        * 
        * Purpose: This function is called getting icd9code information
        * 
        * Description: 
        * This routine returns DataSet which contains icd9code Info
        *
        * ********************************************************************/

        private DataSet Geticd9code(string strCprid, int EncounterId, int ChargeId)
        {

            System.Data.SqlClient.SqlParameter[] icd9codeDsParams = new System.Data.SqlClient.SqlParameter[3];
            icd9codeDsParams[0] = new SqlParameter("@ps_cpr_id", SqlDbType.VarChar);
            icd9codeDsParams[0].Value = strCprid;
            icd9codeDsParams[1] = new SqlParameter("@pl_encounter_id", SqlDbType.Int);
            icd9codeDsParams[1].Value = EncounterId;
            icd9codeDsParams[2] = new SqlParameter("@pl_charge_id", SqlDbType.Int);
            icd9codeDsParams[2].Value = ChargeId;
            return base.ExecuteSql("exec dbo.jmjdoc_get_treatment_assessments @ps_cpr_id,@pl_encounter_id,@pl_charge_id", ref icd9codeDsParams);

        }

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 25-09-2007
        * 
        * Purpose: This function is called getting Alternate user information
        * 
        * Description: 
        * This routine returns DataSet which contains alternate user Info for creating
        * objectid in the Actor Block
        *
        * ********************************************************************/
        private DataSet GetAltUserProgress(string UserId)
        {
            System.Data.SqlClient.SqlParameter[] AltUserDsParams = new System.Data.SqlClient.SqlParameter[1];
            AltUserDsParams[0] = new SqlParameter("@ps_user_id", SqlDbType.VarChar);
            AltUserDsParams[0].Value = UserId;
            return base.ExecuteSql("exec dbo.jmjdoc_get_actor_ids @ps_user_id", ref AltUserDsParams);
        }

        private DataSet GetAltOfficeProgress(string OfficeId)
        {
            System.Data.SqlClient.SqlParameter[] AltUserDsParams = new System.Data.SqlClient.SqlParameter[1];
            AltUserDsParams[0] = new SqlParameter("@ps_office_id", SqlDbType.VarChar);
            AltUserDsParams[0].Value = OfficeId;
            return base.ExecuteSql("exec dbo.jmjdoc_get_actor_ids_for_office @ps_office_id", ref AltUserDsParams);
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called getting Treatment information
        * 
        * Description: 
        * This routine returns DataSet which contains Treatment Info
        *
        * ********************************************************************/
        private DataSet GetTreatment(string TreatmentQuery, string strCprid,
            string context_object, int encounter_id, int objectKey)
        {

            if (TreatmentQuery == "exec dbo.jmjdoc_get_EncDxTreatments @ps_cpr_id,@pl_encounter_id,@pl_problem_id")
            {
                System.Data.SqlClient.SqlParameter[] TreatmentDsParams = new System.Data.SqlClient.SqlParameter[3];
                TreatmentDsParams[0] = new SqlParameter("@ps_cpr_id", SqlDbType.VarChar);
                TreatmentDsParams[0].Value = strCprid;
                TreatmentDsParams[1] = new SqlParameter("@pl_encounter_id", SqlDbType.Int);
                TreatmentDsParams[1].Value = encounter_id;
                TreatmentDsParams[2] = new SqlParameter("@pl_problem_id", SqlDbType.Int);
                TreatmentDsParams[2].Value = objectKey;
                return base.ExecuteSql(TreatmentQuery, ref TreatmentDsParams);
            }
            else
            {
                System.Data.SqlClient.SqlParameter[] TreatmentDsParams = new System.Data.SqlClient.SqlParameter[3];
                TreatmentDsParams[0] = new SqlParameter("@ps_cpr_id", SqlDbType.VarChar);
                TreatmentDsParams[0].Value = strCprid;
                TreatmentDsParams[1] = new SqlParameter("@ps_context_object", SqlDbType.VarChar);
                TreatmentDsParams[1].Value = context_object;
                TreatmentDsParams[2] = new SqlParameter("@pl_object_key", SqlDbType.Int);
                TreatmentDsParams[2].Value = encounter_id;
                return base.ExecuteSql(TreatmentQuery, ref TreatmentDsParams);
            }
        }

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called getting Observation information
        * 
        * Description: 
        * This routine returns DataSet which contains Observation Info
        *
        * ********************************************************************/
        private DataSet GetObservationTreatment(string strCprid, int TreatmentID)
        {
            System.Data.SqlClient.SqlParameter[] ObservationDsParams = new System.Data.SqlClient.SqlParameter[2];
            DataSet ObservationDs = new DataSet();
            ObservationDsParams[0] = new SqlParameter("@ps_cpr_id", SqlDbType.VarChar);
            ObservationDsParams[0].Value = strCprid;
            ObservationDsParams[1] = new SqlParameter("@pl_treatment_id", SqlDbType.Int);
            ObservationDsParams[1].Value = TreatmentID;
            ObservationDs = base.ExecuteSql("exec dbo.jmjdoc_get_obstree_treatment @ps_cpr_id,@pl_treatment_id",
                ref ObservationDsParams);
            return ObservationDs;

        }
        /********************************************************************* 
        * 
        * By: Sumathi                  Date: 3/2/2009
        * 
        * Purpose: This function is called getting Treatment Orders
        * 
        * Description: 
        * This routine returns DataSet which contains order Info
        *
        * ********************************************************************/
        private DataSet GetTreatmentOrder(string strCprid, int TreatmentID)
        {
            System.Data.SqlClient.SqlParameter[] TreatmentOrderDsParams = new System.Data.SqlClient.SqlParameter[2];
            DataSet TreatmentOrderDs = new DataSet();
            TreatmentOrderDsParams[0] = new SqlParameter("@ps_cpr_id", SqlDbType.VarChar);
            TreatmentOrderDsParams[0].Value = strCprid;
            TreatmentOrderDsParams[1] = new SqlParameter("@pl_treatment_id", SqlDbType.Int);
            TreatmentOrderDsParams[1].Value = TreatmentID;
            TreatmentOrderDs = base.ExecuteSql("exec dbo.jmjdoc_get_treatmentorder @ps_cpr_id,@pl_treatment_id",
                ref TreatmentOrderDsParams);
            return TreatmentOrderDs;

        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 10-10-2007
        * 
        * Purpose: This function is called getting All Treatments
        * information
        * 
        * Description: 
        * This routine returns DataSet which contains all Treatment Info
        *
        * ********************************************************************/
        private DataSet GetAllTreatments(string strCprid, int TreatmentID)
        {
            DataSet AllTreatmentDs = new DataSet();
            System.Data.SqlClient.SqlParameter[] AllTreamtmentDsParams = new System.Data.SqlClient.SqlParameter[0];
            AllTreatmentDs = base.ExecuteSql("select * from dbo.fn_treatment_tree('" + strCprid + "'," + TreatmentID + ")", ref AllTreamtmentDsParams);
            return AllTreatmentDs;
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called getting Treatment Medication
        * information
        * 
        * Description: 
        * This routine returns DataSet which contains Treatment Medication Info
        *
        * ********************************************************************/
        private DataSet GetTreatmentMedication(string strCprid, int TreatmentID)
        {
            System.Data.SqlClient.SqlParameter[] MedicationDsParams = new System.Data.SqlClient.SqlParameter[2];
            DataSet MedicationDs = new DataSet();
            MedicationDsParams[0] = new SqlParameter("@ps_cpr_id", SqlDbType.VarChar);
            MedicationDsParams[0].Value = strCprid;
            MedicationDsParams[1] = new SqlParameter("@pl_object_key", SqlDbType.Int);
            MedicationDsParams[1].Value = TreatmentID;
            MedicationDs = base.ExecuteSql("exec dbo.jmjdoc_get_treatment_medication @ps_cpr_id,@pl_object_key",
                ref MedicationDsParams);
            return MedicationDs;

        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * Modified By: Nitin Vikraman		  Date: 21-08-2007
        * 
        * Purpose: This function is called for the creation of Treatment,
        * TreatmentNote, Observation Nodes and Observation Result Nodes
        * 
        * Description: 
        * This routine returns Treatment,TreatmentNote, Observation associated 
        * with the treatment and the observationresult nodes.
        *
        * ********************************************************************/
        private void CreateTreatment(XmlDocument objJMJXmlDoc, XmlDocument JMJComponentDataDoc, XmlNode objJMJXmlPatient,
            XmlNode objJMJXmlActors, XmlNode objJMJMapperTempTreatment, XmlNode MapperConstitutentTreatment, XmlNodeList objJMJMapperTempActorList,
            DataRow TreatmentDr, int AssessmentID, string strCprid)
        {
            try
            {
                XmlNode objJMJXmlTreatment = null;
                DataSet AllTreatmentDs = null;
                DataSet TreatmentDs = null;
                DataRow AllTreatmentDr = null;
                DataRow SearchTreatmentDr = null;
                string ParentTreatmentId = "";
                string TreatmentId = "";
                AllTreatmentDs = GetAllTreatments(strCprid, Convert.ToInt32(TreatmentDr["treatmentid"].ToString()));
                if (objJMJMapperTempTreatment.Name == "Treatment")
                {
                    for (int i = 0; i < AllTreatmentDs.Tables[0].Rows.Count; i++)
                    {
                        AllTreatmentDr = AllTreatmentDs.Tables[0].Rows[i];
                        if (!IsDataRowNull(AllTreatmentDr, "level") && !IsDataRowNull(AllTreatmentDr, "treatment_id") &&
                            (AllTreatmentDr["level"].ToString() == "1") && AllTreatmentDs.Tables[0].Rows.Count > 1)
                        {
                            TreatmentDs = GetTreatment("exec dbo.jmjdoc_get_treatment @ps_cpr_id,@ps_context_object,@pl_object_key", strCprid, "Treatment", Convert.ToInt32(AllTreatmentDr["treatment_id"].ToString()), 0);
                            TreatmentDr = TreatmentDs.Tables[0].Rows[0];
                        }
                    }
                }
                objJMJXmlTreatment = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objJMJMapperTempTreatment.Name, null);
                objJMJXmlPatient.AppendChild(objJMJXmlTreatment);


                if (objJMJMapperTempTreatment.ChildNodes.Count > 0 &&
                    objJMJMapperTempTreatment.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempTreatment.Attributes.Count > 0)
                    {
                        if (objJMJMapperTempTreatment.Attributes["TreatmentID"] != null)
                        {
                            if (objJMJMapperTempTreatment.Attributes["TreatmentID"].Value != "")
                            {
                                XmlAttribute objTreatmentAttrib = objJMJXmlDoc.CreateAttribute("TreatmentID");
                                objTreatmentAttrib.Value = TreatmentDr[objJMJMapperTempTreatment.Attributes["TreatmentID"].Value].ToString();
                                objJMJXmlTreatment.Attributes.Append(objTreatmentAttrib);

                            }
                        }

                    }
                    foreach (XmlNode objXmlTreatmentNode in objJMJMapperTempTreatment.ChildNodes)
                    {
                        if (objXmlTreatmentNode.NodeType == XmlNodeType.Element)
                        {

                            if (objXmlTreatmentNode.Name == "TreatmentNote")
                            {
                                DataRow TreatmentNoteDr = null;
                                DataSet TreatmentNoteDs = new DataSet();
                                TreatmentNoteDs = getProgress(strCprid, "Treatment", Convert.ToInt32(TreatmentDr["treatmentid"].ToString()), null, null, null);
                                for (int iTreatmentNote = 0; iTreatmentNote < TreatmentNoteDs.Tables[0].Rows.Count; iTreatmentNote++)
                                {
                                    TreatmentNoteDr = TreatmentNoteDs.Tables[0].Rows[iTreatmentNote];
                                    XmlNode objJMJTreatmentNote = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlTreatmentNode.Name, null);
                                    objJMJXmlTreatment.AppendChild(objJMJTreatmentNote);
                                    CreateTreatmentNote(objJMJXmlDoc, objJMJTreatmentNote,
                                        objXmlTreatmentNode, TreatmentNoteDr);

                                }

                            }
                            else if (objXmlTreatmentNode.Name == "Medication")
                            {
                                DataRow MedicationDr = null;
                                TreatmentId = TreatmentDr[MapperConstitutentTreatment.SelectSingleNode("//Treatment").Attributes["TreatmentID"].Value].ToString();

                                XmlNodeList objSelectTrMedicationList = objJMJXmlPatient.SelectNodes("//JMJDocument/PatientRecord/Treatment/TreatmentType");

                                XmlNode objSelectTrMedication = objSelectTrMedicationList[objSelectTrMedicationList.Count - 1];
                                if (objSelectTrMedication != null)
                                {
                                    if (objSelectTrMedication.InnerText == "MEDICATION")
                                    {
                                        DataSet MedicationDs = new DataSet();
                                        MedicationDs = GetTreatmentMedication(strCprid, Convert.ToInt32(TreatmentDr["treatmentid"].ToString()));
                                        for (int iMedication = 0; iMedication < MedicationDs.Tables[0].Rows.Count; iMedication++)
                                        {
                                            MedicationDr = MedicationDs.Tables[0].Rows[iMedication];
                                            CreateTreatmentMedication(objJMJXmlDoc, objJMJXmlPatient, objJMJXmlTreatment, objXmlTreatmentNode, MedicationDr, TreatmentId);
                                        }
                                    }
                                }
                            }
                            else if (objXmlTreatmentNode.Name == "Message" || objXmlTreatmentNode.Name == "TreatmentHandling")
                            {
                            }
                            else if (objXmlTreatmentNode.Name == "Order") // sumathi added this 2/28/2009
                            {
                                // no of orders as repeating node for the treatment
                                /*		int TrtLastOrderEncounter = 0;
                                        string TrtLastOrderedDate=null,TrtLastOrderedBy=null;*/
                                DataSet TreatmentOrderDs = new DataSet();
                                DataRow TreatmentOrderDr = null;
                                TreatmentOrderDs = GetTreatmentOrder(strCprid, Convert.ToInt32(TreatmentDr["treatmentid"].ToString()));
                                for (int iOrder = 0; iOrder < TreatmentOrderDs.Tables[0].Rows.Count; iOrder++)
                                {
                                    TreatmentOrderDr = TreatmentOrderDs.Tables[0].Rows[iOrder];
                                    XmlNode objJMJTreatmentOrder = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlTreatmentNode.Name, null);
                                    objJMJXmlTreatment.AppendChild(objJMJTreatmentOrder);
                                    CreateTreatmentOrder(objJMJXmlDoc, objJMJTreatmentOrder,
                                        objXmlTreatmentNode, TreatmentOrderDr);
                                    /*									if(TreatmentOrderDr["encounter_id"] != System.DBNull.Value)
                                                                            TrtLastOrderEncounter = Convert.ToInt32(TreatmentOrderDr["encounter_id"].ToString());
                                                                        if(TreatmentOrderDr["ordered_date"] != System.DBNull.Value)
                                                                            TrtLastOrderedDate = TreatmentOrderDr["ordered_date"].ToString();
                                                                        if(TreatmentOrderDr["ordered_by"] != System.DBNull.Value)
                                                                            TrtLastOrderedBy = TreatmentOrderDr["ordered_by"].ToString();*/
                                }
                                /*							if(TrtLastOrderedBy != "" )
                                                            {
                                                                XmlNode lastOrderBy = null;
                                                                lastOrderBy = objJMJXmlDoc.SelectSingleNode("LastOrderedBy");
                                                                if( lastOrderBy != null && lastOrderBy.InnerText == "")
                                                                    lastOrderBy.InnerText = TrtLastOrderedBy.ToString();
                                                                else
                                                                {
                                                                    lastOrderBy = objJMJXmlDoc.CreateNode(XmlNodeType.Element,"LastOrderedBy",null);
                                                                    objJMJXmlTreatment.AppendChild(lastOrderBy);
                                                                    lastOrderBy.InnerText = TrtLastOrderedBy.ToString();
                                                                }
                                                            }
                                                            if(TrtLastOrderedDate != "")
                                                            {
                                                                XmlNode lastOrderDate = null;
                                                                lastOrderDate = objJMJXmlDoc.SelectSingleNode("LastOrderedDate");
                                                                if( lastOrderDate != null && lastOrderDate.InnerText == "")
                                                                    lastOrderDate.InnerText = TrtLastOrderedDate.ToString();
                                                                else
                                                                {
                                                                    lastOrderDate = objJMJXmlDoc.CreateNode(XmlNodeType.Element,"LastOrderedDate",null);
                                                                    objJMJXmlTreatment.AppendChild(lastOrderDate);
                                                                    lastOrderDate.InnerText = TrtLastOrderedDate.ToString();
                                                                }
                                                            }
                                                            if(TrtLastOrderEncounter > 0 && objJMJXmlDoc.SelectSingleNode("LastOrderedEncounter") == null) // check to see last ordered encounter block exists if not create one
                                                            {
                                                                XmlNode lastOrderEnc = null;
                                                                lastOrderEnc = objJMJXmlDoc.SelectSingleNode("LastOrderedEncounter");
                                                                if( lastOrderEnc != null && lastOrderEnc.InnerText == "")
                                                                    lastOrderEnc.InnerText = TrtLastOrderEncounter.ToString();
                                                                else
                                                                {
                                                                    lastOrderEnc = objJMJXmlDoc.CreateNode(XmlNodeType.Element,"LastOrderedEncounter",null);
                                                                    objJMJXmlTreatment.AppendChild(lastOrderEnc);
                                                                    lastOrderEnc.InnerText = TrtLastOrderEncounter.ToString();
                                                                }


                                                                // Check if the Encounter exist with Encounter.encounterid=last ordered encounter
                                                                DataSet EncounterDs=null,EncounterNoteDs=null;
                                                                DataRow EncounterDr = null;
                                                                XmlNodeList EncounterJMJValueNodeList = null;

                                                                EncounterJMJValueNodeList=objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                                                                if(EncounterJMJValueNodeList.Count>0)
                                                                {
                                                                    bool ContainsEncounter=false;
                                                                    for(int iCounter=0;iCounter<EncounterJMJValueNodeList.Count;iCounter++)
                                                                    {
                                                                        if(Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText)==TrtLastOrderEncounter)
                                                                        {
                                                                            ContainsEncounter=true;
                                                                            // Modify the Encounter node
                                                                            EncounterDs=GetEncounter(strCprid,TrtLastOrderEncounter);
                                                                            EncounterDr=EncounterDs.Tables[0].Rows[0];
                                                                            EncounterNoteDs=getProgress(strCprid,"Encounter",TrtLastOrderEncounter,null,null,null);
                                                                            XmlNode JMJEncounterNode=objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter];
                                                                            if(Convert.ToInt32(JMJEncounterNode.Attributes["EncounterID"].Value)==Convert.ToInt32( EncounterDr["encounterid"].ToString()))
                                                                            {
                                                                                UpdateEncounter(objJMJXmlDoc,objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter],
                                                                                    objJMJXmlActors,objJMJXmlMapperTemplate2.SelectSingleNode("//JMJDocument/Encounter"),
                                                                                    objJMJMapperTempActorList,EncounterDr,EncounterNoteDs);
                                                                                break;
                                                                            }
								
                                                                        }
                                                                        else if(ContainsEncounter==false && ((iCounter+1)==EncounterJMJValueNodeList.Count))
                                                                        {
                                                                            ProcessEncounterContext(TrtLastOrderEncounter,strCprid,objJMJXmlDoc,
                                                                                objJMJXmlActors,objJMJXmlMapperTemplate2);
                                                                        }
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    ProcessEncounterContext(TrtLastOrderEncounter,strCprid,objJMJXmlDoc,
                                                                        objJMJXmlActors,objJMJXmlMapperTemplate2);
                                                                }
                                                            }*/

                            }
                            else if (objXmlTreatmentNode.Name == "Observation")
                            {

                                DataSet ObservationDs = new DataSet();
                                DataSet TreatmentObxNoteDs = new DataSet();
                                ObservationDs = GetObservationTreatment(strCprid, Convert.ToInt32(TreatmentDr["treatmentid"].ToString()));
                                TreatmentObxNoteDs = getProgress(strCprid, "Observation", Convert.ToInt32(TreatmentDr["treatmentid"].ToString()), null, null, null);
                                CreateObservation(objJMJXmlDoc, objJMJXmlTreatment, objXmlTreatmentNode,
                                    TreatmentDr, ObservationDs, TreatmentObxNoteDs);
                            }
                            else if (objXmlTreatmentNode.Name == "ConstituentTreatments")
                            {
                                bool isExistConstitutentTreatment = false;
                                XmlNode ConsitutentTreatmentNode = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "ConstituentTreatments", null);
                                objJMJXmlTreatment.AppendChild(ConsitutentTreatmentNode);

                                //								for(int i=0;i<AllTreatmentDs.Tables[0].Rows.Count;i++)
                                //								{
                                AllTreatmentDr = AllTreatmentDs.Tables[0].Rows[0];
                                //									if(!IsDataRowNull(AllTreatmentDr,"treatment_id") && 
                                //										!IsDataRowNull(AllTreatmentDr,"parent_treatment_id") ) 
                                //										{
                                //											isExistConstitutentTreatment=true;
                                ParentTreatmentId = AllTreatmentDr["treatment_id"].ToString();
                                for (int j = 0; j < AllTreatmentDs.Tables[0].Rows.Count; j++)
                                {
                                    SearchTreatmentDr = AllTreatmentDs.Tables[0].Rows[j];
                                    if (!IsDataRowNull(SearchTreatmentDr, "treatment_id") &&
                                        !IsDataRowNull(SearchTreatmentDr, "parent_treatment_id") &&
                                        (ParentTreatmentId == SearchTreatmentDr["parent_treatment_id"].ToString()))
                                    {
                                        DataSet ConstitutentTreatmentDs = GetTreatment("exec dbo.jmjdoc_get_treatment @ps_cpr_id,@ps_context_object,@pl_object_key", strCprid, "Treatment", Convert.ToInt32(SearchTreatmentDr["treatment_id"].ToString()), 0);
                                        isExistConstitutentTreatment = true;
                                        CreateConstitutentTreatment(objJMJXmlDoc, JMJComponentDataDoc, ConsitutentTreatmentNode,
                                            objJMJXmlActors, MapperConstitutentTreatment, MapperConstitutentTreatment, objJMJMapperTempActorList, AllTreatmentDs,
                                            ConstitutentTreatmentDs.Tables[0].Rows[0], AssessmentID, strCprid, SearchTreatmentDr["treatment_id"].ToString());
                                    }
                                }
                                //}
                                ///}
                                if (!isExistConstitutentTreatment)
                                {
                                    objJMJXmlTreatment.RemoveChild(ConsitutentTreatmentNode);
                                }
                            }
                            else
                            {
                                CreateTreatment(objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlTreatment, objJMJXmlActors,
                                    objXmlTreatmentNode, MapperConstitutentTreatment, objJMJMapperTempActorList,
                                    TreatmentDr, AssessmentID, strCprid);
                            }
                        }
                        else if (objXmlTreatmentNode.NodeType == XmlNodeType.Text
                            && objXmlTreatmentNode.Name == "#text")
                        {

                            if (!IsDataRowNull(TreatmentDr, objXmlTreatmentNode.InnerText))
                            {
                                // Condition to check Check for null values in the datarow
                                // If condition true , then set the node text
                                if (TreatmentDr[objXmlTreatmentNode.InnerText] != System.DBNull.Value)
                                {
                                    bool ContainsFlag = false;
                                    if (objJMJMapperTempTreatment.Name == "BeginDate" ||
                                        objJMJMapperTempTreatment.Name == "EndDate" || objJMJMapperTempTreatment.Name == "LastOrderedDateTime")
                                    {

                                        objJMJXmlTreatment.InnerText = Convert.ToDateTime(TreatmentDr[objXmlTreatmentNode.InnerText]
                                            .ToString()).ToString("u");
                                    }
                                    else if (objJMJMapperTempTreatment.Name == "LastOrderedEncounter") // begin last ordered encounter check
                                    {
                                        objJMJXmlTreatment.InnerText = TreatmentDr[objXmlTreatmentNode.InnerText].ToString();
                                        // Check if the Encounter exist with Encounter.encounterid=last ordered encounter
                                        DataSet EncounterDs = null, EncounterNoteDs = null;
                                        DataRow EncounterDr = null;
                                        XmlNodeList EncounterJMJValueNodeList = null;
                                        int TrtLastOrderEncounter = 0;
                                        TrtLastOrderEncounter = Convert.ToInt32(TreatmentDr[objXmlTreatmentNode.InnerText]);

                                        EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                                        if (EncounterJMJValueNodeList.Count > 0)
                                        {
                                            bool ContainsEncounter = false;
                                            for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                                            {
                                                if (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) == TrtLastOrderEncounter)
                                                {
                                                    ContainsEncounter = true;
                                                    // Modify the Encounter node
                                                    EncounterDs = GetEncounter(strCprid, TrtLastOrderEncounter);
                                                    EncounterDr = EncounterDs.Tables[0].Rows[0];
                                                    EncounterNoteDs = getProgress(strCprid, "Encounter", TrtLastOrderEncounter, null, null, null);
                                                    XmlNode JMJEncounterNode = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter];
                                                    if (Convert.ToInt32(JMJEncounterNode.Attributes["EncounterID"].Value) == Convert.ToInt32(EncounterDr["encounterid"].ToString()))
                                                    {
                                                        UpdateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter],
                                                            objJMJXmlActors, objJMJXmlMapperTemplate2.SelectSingleNode("//JMJDocument/Encounter"),
                                                            objJMJMapperTempActorList, EncounterDr, EncounterNoteDs);
                                                        break;
                                                    }

                                                }
                                                else if (ContainsEncounter == false && ((iCounter + 1) == EncounterJMJValueNodeList.Count))
                                                {
                                                    ProcessEncounterContext(TrtLastOrderEncounter, strCprid, objJMJXmlDoc,
                                                        objJMJXmlActors, objJMJXmlMapperTemplate2);
                                                }
                                            }
                                        }
                                        else
                                        {
                                            ProcessEncounterContext(TrtLastOrderEncounter, strCprid, objJMJXmlDoc,
                                                objJMJXmlActors, objJMJXmlMapperTemplate2);
                                        }
                                    } // end of last ordered encounter check
                                    else if (objJMJMapperTempTreatment.Name == "OrderedBy")
                                    {
                                        objJMJXmlTreatment.InnerText = TreatmentDr[objXmlTreatmentNode.InnerText].ToString();
                                        // Code for creation of Actor Nodes
                                        XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                        int jCounter = 0;
                                        for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                        {
                                            if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJXmlTreatment.InnerText)
                                            {
                                                ContainsFlag = true;
                                                break;
                                            }
                                        }
                                        if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                        {
                                            for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                            {
                                                if (objJMJMapperTempActorList[iCounter].Name == "ActorOrderedBy")
                                                {
                                                    CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                        TreatmentDr);
                                                }
                                            }
                                        }
                                    }
                                    else if (objJMJMapperTempTreatment.Name == "LastOrderedBy")
                                    {
                                        objJMJXmlTreatment.InnerText = TreatmentDr[objXmlTreatmentNode.InnerText].ToString();
                                        // Code for creation of Actor Nodes
                                        XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                        int jCounter = 0;
                                        for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                        {
                                            if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJXmlTreatment.InnerText)
                                            {
                                                ContainsFlag = true;
                                                break;
                                            }
                                        }
                                        if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                        {
                                            for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                            {
                                                if (objJMJMapperTempActorList[iCounter].Name == "ActorTreatmentLastOrderedBy")
                                                {
                                                    CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                        TreatmentDr);
                                                }
                                            }
                                        }
                                    }
                                    else if (objJMJMapperTempTreatment.Name == "OrderedFor")
                                    {
                                        objJMJXmlTreatment.InnerText = TreatmentDr[objXmlTreatmentNode.InnerText].ToString();
                                        // Code for creation of Actor Nodes
                                        if (objJMJXmlTreatment.InnerText != "")
                                        {
                                            XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                            int jCounter = 0;
                                            for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                            {
                                                if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJXmlTreatment.InnerText)
                                                {
                                                    ContainsFlag = true;
                                                    break;
                                                }
                                            }
                                            if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                            {
                                                for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                                {
                                                    if (objJMJMapperTempActorList[iCounter].Name == "ActorTreatmentOrderedFor")
                                                    {
                                                        CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                            TreatmentDr);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else if (objJMJMapperTempTreatment.Name == "CompletedBy")
                                    {
                                        objJMJXmlTreatment.InnerText = TreatmentDr[objXmlTreatmentNode.InnerText].ToString();
                                        // Code for creation of Actor Nodes
                                        XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                        int jCounter = 0;
                                        for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                        {
                                            if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJXmlTreatment.InnerText)
                                            {
                                                ContainsFlag = true;
                                                break;
                                            }
                                        }
                                        if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                        {
                                            for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                            {
                                                if (objJMJMapperTempActorList[iCounter].Name == "ActorTreatmentCompletedBy")
                                                {
                                                    CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                        TreatmentDr);
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        objJMJXmlTreatment.InnerText = TreatmentDr[objXmlTreatmentNode.InnerText].ToString();
                                    }
                                    if (objJMJXmlTreatment.InnerText == "")
                                    {
                                        objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                                    }
                                }
                                // If the condition false, then remove the node
                                else
                                {
                                    objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                                }
                            }
                            else
                            {
                                objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                            }

                        }
                    }
                }
                else if (objJMJMapperTempTreatment.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempTreatment.Attributes.Count > 0)
                    {
                        if (objJMJMapperTempTreatment.Attributes["default"] != null)
                        {
                            if (objJMJMapperTempTreatment.Attributes["default"].Value != "")
                            {
                                objJMJXmlTreatment.InnerText = objJMJMapperTempTreatment.
                                    Attributes["default"].Value;

                            }
                        }

                    }
                    else if (objJMJMapperTempTreatment.Name == "Assessment" && AssessmentID != 0)
                    {
                        objJMJXmlTreatment.InnerText = AssessmentID.ToString();
                    }
                    else if (objJMJMapperTempTreatment.InnerText == "" && !objJMJMapperTempTreatment.HasChildNodes)
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                    }

                }
                else if (objJMJMapperTempTreatment.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempTreatment.InnerText == "" && !objJMJMapperTempTreatment.HasChildNodes)
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                    }

                }

                // Conditions to check if the <ObjectID>.<JMJValue> is null then
                // remove <ObjectID> from the parent node
                // objJMJXmlPatient.AppendChild(objJMJXmlTreatment);
                if (objJMJXmlTreatment.Name == "ObjectID")
                {
                    if (objJMJXmlTreatment.SelectSingleNode("JMJValue") == null)
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                    }
                    else if (objJMJXmlTreatment.SelectSingleNode("JMJValue").InnerText == "")
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                    }

                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error in Treatment Nodes creation", ex);
            }
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 09-10-2007
        * 
        * Purpose: 
        * 
        * Description: 
        *
        *
        * ********************************************************************/
        private void ProcessConstitutentTreatment(XmlDocument objJMJXmlDoc, XmlDocument JMJComponentDataDoc, XmlNode objJMJXmlPatient,
            XmlNode objJMJXmlActors, XmlNode objJMJMapperTempTreatment, XmlNodeList objJMJMapperTempActorList,
            DataSet AllTreatmentDs, DataRow TreatmentDr, int AssessmentID, string strCprid, string ParentTreatmentId)
        {

        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 09-10-2007
        * 
        * Purpose: This function is called for the creation of ConsitutentTreatment,
        * TreatmentNote
        * 
        * Description: 
        * This routine returns Treatment,TreatmentNote nodes.
        *
        * ********************************************************************/
        private void CreateConstitutentTreatment(XmlDocument objJMJXmlDoc, XmlDocument JMJComponentDataDoc, XmlNode objJMJXmlPatient,
            XmlNode objJMJXmlActors, XmlNode objJMJMapperTempTreatment, XmlNode MapperConstitutentTreatment,
            XmlNodeList objJMJMapperTempActorList, DataSet AllTreatmentDs, DataRow TreatmentDr, int AssessmentID,
            string strCprid, string ParentTreatmentId)
        {
            try
            {
                XmlNode objJMJXmlTreatment = null;
                DataRow SearchTreatmentDr = null;
                string TreatmentId = "";
                objJMJXmlTreatment = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objJMJMapperTempTreatment.Name, null);
                objJMJXmlPatient.AppendChild(objJMJXmlTreatment);


                if (objJMJMapperTempTreatment.ChildNodes.Count > 0 &&
                    objJMJMapperTempTreatment.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempTreatment.Attributes.Count > 0)
                    {
                        if (objJMJMapperTempTreatment.Attributes["TreatmentID"] != null)
                        {
                            if (objJMJMapperTempTreatment.Attributes["TreatmentID"].Value != "")
                            {
                                XmlAttribute objTreatmentAttrib = objJMJXmlDoc.CreateAttribute("TreatmentID");
                                objTreatmentAttrib.Value = ParentTreatmentId;
                                objJMJXmlTreatment.Attributes.Append(objTreatmentAttrib);

                            }
                        }

                    }
                    foreach (XmlNode objXmlTreatmentNode in objJMJMapperTempTreatment.ChildNodes)
                    {
                        if (objXmlTreatmentNode.NodeType == XmlNodeType.Element)
                        {

                            if (objXmlTreatmentNode.Name == "TreatmentNote")
                            {
                                DataRow TreatmentNoteDr = null;
                                DataSet TreatmentNoteDs = new DataSet();
                                TreatmentNoteDs = getProgress(strCprid, "Treatment", Convert.ToInt32(TreatmentDr["treatmentid"].ToString()), null, null, null);
                                for (int iTreatmentNote = 0; iTreatmentNote < TreatmentNoteDs.Tables[0].Rows.Count; iTreatmentNote++)
                                {
                                    TreatmentNoteDr = TreatmentNoteDs.Tables[0].Rows[iTreatmentNote];
                                    XmlNode objJMJTreatmentNote = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlTreatmentNode.Name, null);
                                    objJMJXmlTreatment.AppendChild(objJMJTreatmentNote);
                                    CreateTreatmentNote(objJMJXmlDoc, objJMJTreatmentNote,
                                        objXmlTreatmentNode, TreatmentNoteDr);

                                }

                            }
                            else if (objXmlTreatmentNode.Name == "Medication")
                            {
                                DataRow MedicationDr = null;
                                TreatmentId = TreatmentDr[MapperConstitutentTreatment.SelectSingleNode("//Treatment").Attributes["TreatmentID"].Value].ToString();
                                XmlNodeList objSelectTrMedicationList = objJMJXmlPatient.SelectNodes("//JMJDocument/PatientRecord/Treatment/TreatmentType");

                                XmlNode objSelectTrMedication = objSelectTrMedicationList[objSelectTrMedicationList.Count - 1];
                                if (objSelectTrMedication != null)
                                {
                                    if (objSelectTrMedication.InnerText == "MEDICATION")
                                    {
                                        DataSet MedicationDs = new DataSet();
                                        MedicationDs = GetTreatmentMedication(strCprid, Convert.ToInt32(TreatmentDr["treatmentid"].ToString()));
                                        for (int iMedication = 0; iMedication < MedicationDs.Tables[0].Rows.Count; iMedication++)
                                        {
                                            MedicationDr = MedicationDs.Tables[0].Rows[iMedication];
                                            CreateTreatmentMedication(objJMJXmlDoc, objJMJXmlPatient, objJMJXmlTreatment, objXmlTreatmentNode, MedicationDr, TreatmentId);
                                        }
                                    }
                                }
                            }
                            else if (objXmlTreatmentNode.Name == "Message" || objXmlTreatmentNode.Name == "TreatmentHandling")
                            {
                            }
                            else if (objXmlTreatmentNode.Name == "Order") // sumathi added this 3/4/2009
                            {
                                // no of orders as repeating node for the treatment
                                DataSet TreatmentOrderDs = new DataSet();
                                DataRow TreatmentOrderDr = null;
                                TreatmentOrderDs = GetTreatmentOrder(strCprid, Convert.ToInt32(TreatmentDr["treatmentid"].ToString()));
                                for (int iOrder = 0; iOrder < TreatmentOrderDs.Tables[0].Rows.Count; iOrder++)
                                {
                                    TreatmentOrderDr = TreatmentOrderDs.Tables[0].Rows[iOrder];
                                    XmlNode objJMJTreatmentOrder = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlTreatmentNode.Name, null);
                                    objJMJXmlTreatment.AppendChild(objJMJTreatmentOrder);
                                    CreateTreatmentOrder(objJMJXmlDoc, objJMJTreatmentOrder,
                                        objXmlTreatmentNode, TreatmentOrderDr);
                                }
                            }
                            else if (objXmlTreatmentNode.Name == "Observation")
                            {

                                DataSet ObservationDs = new DataSet();
                                DataSet TreatmentObxNoteDs = new DataSet();
                                ObservationDs = GetObservationTreatment(strCprid, Convert.ToInt32(TreatmentDr["treatmentid"].ToString()));
                                TreatmentObxNoteDs = getProgress(strCprid, "Observation", Convert.ToInt32(TreatmentDr["treatmentid"].ToString()), null, null, null);
                                CreateObservation(objJMJXmlDoc, objJMJXmlTreatment, objXmlTreatmentNode,
                                    TreatmentDr, ObservationDs, TreatmentObxNoteDs);
                            }
                            else if (objXmlTreatmentNode.Name == "ConstitutentTreatment")
                            {
                                XmlNode ConsitutentTreatmentNode = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "ConstituentTreatment", null);
                                objJMJXmlTreatment.AppendChild(ConsitutentTreatmentNode);
                                for (int i = 0; i < AllTreatmentDs.Tables[0].Rows.Count; i++)
                                {
                                    SearchTreatmentDr = AllTreatmentDs.Tables[0].Rows[i];
                                    if (!IsDataRowNull(SearchTreatmentDr, "treatment_id") &&
                                        !IsDataRowNull(SearchTreatmentDr, "parent_treatment_id") &&
                                        (ParentTreatmentId == SearchTreatmentDr["parent_treatment_id"].ToString()))
                                    {
                                        DataSet ConstitutentTreatmentDs = GetTreatment("exec dbo.jmjdoc_get_treatment @ps_cpr_id,@ps_context_object,@pl_object_key", strCprid, "Treatment", Convert.ToInt32(SearchTreatmentDr["treatment_id"].ToString()), 0);
                                        CreateConstitutentTreatment(objJMJXmlDoc, JMJComponentDataDoc, ConsitutentTreatmentNode,
                                            objJMJXmlActors, MapperConstitutentTreatment, MapperConstitutentTreatment, objJMJMapperTempActorList, AllTreatmentDs,
                                            ConstitutentTreatmentDs.Tables[0].Rows[0], AssessmentID, strCprid, SearchTreatmentDr["treatment_id"].ToString());
                                    }
                                }
                                if (!ConsitutentTreatmentNode.HasChildNodes)
                                {
                                    objJMJXmlTreatment.RemoveChild(ConsitutentTreatmentNode);
                                }

                            }
                            else
                            {
                                CreateConstitutentTreatment(objJMJXmlDoc, JMJComponentDataDoc, objJMJXmlTreatment, objJMJXmlActors,
                                    objXmlTreatmentNode, MapperConstitutentTreatment, objJMJMapperTempActorList, AllTreatmentDs,
                                    TreatmentDr, AssessmentID, strCprid, ParentTreatmentId);
                            }
                        }
                        else if (objXmlTreatmentNode.NodeType == XmlNodeType.Text
                            && objXmlTreatmentNode.Name == "#text")
                        {

                            if (!IsDataRowNull(TreatmentDr, objXmlTreatmentNode.InnerText))
                            {
                                // Condition to check Check for null values in the datarow
                                // If condition true , then set the node text
                                if (TreatmentDr[objXmlTreatmentNode.InnerText] != System.DBNull.Value)
                                {
                                    bool ContainsFlag = false;
                                    if (objJMJMapperTempTreatment.Name == "BeginDate" ||
                                        objJMJMapperTempTreatment.Name == "EndDate" || objJMJMapperTempTreatment.Name == "LastOrderedDateTime")
                                    {

                                        objJMJXmlTreatment.InnerText = Convert.ToDateTime(TreatmentDr[objXmlTreatmentNode.InnerText]
                                            .ToString()).ToString("u");
                                    }
                                    else if (objJMJMapperTempTreatment.Name == "LastOrderedEncounter") // Sumathi Added 3/4/2009
                                    {
                                        DataSet EncounterDs = null, EncounterNoteDs = null;
                                        DataRow EncounterDr = null;
                                        XmlNodeList EncounterJMJValueNodeList = null;
                                        objJMJXmlTreatment.InnerText = TreatmentDr[objXmlTreatmentNode.InnerText].ToString();
                                        int TrtLastOrderEncounter = Convert.ToInt32(TreatmentDr[objXmlTreatmentNode.InnerText].ToString());
                                        // check to see if the <Encounter> node is created if not create one
                                        // Check if the Encounter exist with Encounter.encounterid=last ordered encounter
                                        EncounterJMJValueNodeList = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter/ObjectID/JMJValue");
                                        if (EncounterJMJValueNodeList.Count > 0)
                                        {
                                            bool ContainsEncounter = false;
                                            for (int iCounter = 0; iCounter < EncounterJMJValueNodeList.Count; iCounter++)
                                            {
                                                if (Convert.ToInt32(EncounterJMJValueNodeList[iCounter].InnerText) == TrtLastOrderEncounter)
                                                {
                                                    ContainsEncounter = true;
                                                    // Modify the Encounter node
                                                    EncounterDs = GetEncounter(strCprid, TrtLastOrderEncounter);
                                                    EncounterDr = EncounterDs.Tables[0].Rows[0];
                                                    EncounterNoteDs = getProgress(strCprid, "Encounter", TrtLastOrderEncounter, null, null, null);
                                                    XmlNode JMJEncounterNode = objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter];
                                                    if (Convert.ToInt32(JMJEncounterNode.Attributes["EncounterID"].Value) == Convert.ToInt32(EncounterDr["encounterid"].ToString()))
                                                    {
                                                        UpdateEncounter(objJMJXmlDoc, objJMJXmlDoc.SelectNodes("//JMJDocument/PatientRecord/Encounter")[iCounter],
                                                            objJMJXmlActors, objJMJXmlMapperTemplate2.SelectSingleNode("//JMJDocument/Encounter"),
                                                            objJMJMapperTempActorList, EncounterDr, EncounterNoteDs);
                                                        break;
                                                    }

                                                }
                                                else if (ContainsEncounter == false && ((iCounter + 1) == EncounterJMJValueNodeList.Count))
                                                {
                                                    ProcessEncounterContext(TrtLastOrderEncounter, strCprid, objJMJXmlDoc,
                                                        objJMJXmlActors, objJMJXmlMapperTemplate2);
                                                }
                                            }
                                        }
                                        else
                                        {
                                            ProcessEncounterContext(TrtLastOrderEncounter, strCprid, objJMJXmlDoc,
                                                objJMJXmlActors, objJMJXmlMapperTemplate2);
                                        }
                                    }
                                    else if (objJMJMapperTempTreatment.Name == "OrderedBy")
                                    {
                                        objJMJXmlTreatment.InnerText = TreatmentDr[objXmlTreatmentNode.InnerText].ToString();
                                        // Code for creation of Actor Nodes
                                        XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                        int jCounter = 0;
                                        for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                        {
                                            if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJXmlTreatment.InnerText)
                                            {
                                                ContainsFlag = true;
                                                break;
                                            }
                                        }
                                        if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                        {
                                            for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                            {
                                                if (objJMJMapperTempActorList[iCounter].Name == "ActorOrderedBy")
                                                {
                                                    CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                        TreatmentDr);
                                                }
                                            }
                                        }
                                    }
                                    else if (objJMJMapperTempTreatment.Name == "LastOrderedBy") // Sumathi Added 3/4/2009
                                    {
                                        objJMJXmlTreatment.InnerText = TreatmentDr[objXmlTreatmentNode.InnerText].ToString();
                                        // Code for creation of Actor Nodes
                                        XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                        int jCounter = 0;
                                        for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                        {
                                            if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJXmlTreatment.InnerText)
                                            {
                                                ContainsFlag = true;
                                                break;
                                            }
                                        }
                                        if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                        {
                                            for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                            {
                                                if (objJMJMapperTempActorList[iCounter].Name == "ActorTreatmentLastOrderedBy")
                                                {
                                                    CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                        TreatmentDr);
                                                }
                                            }
                                        }
                                    }
                                    else if (objJMJMapperTempTreatment.Name == "OrderedFor")
                                    {
                                        objJMJXmlTreatment.InnerText = TreatmentDr[objXmlTreatmentNode.InnerText].ToString();
                                        // Code for creation of Actor Nodes
                                        if (objJMJXmlTreatment.InnerText != "")
                                        {
                                            XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                            int jCounter = 0;
                                            for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                            {
                                                if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJXmlTreatment.InnerText)
                                                {
                                                    ContainsFlag = true;
                                                    break;
                                                }
                                            }
                                            if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                            {
                                                for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                                {
                                                    if (objJMJMapperTempActorList[iCounter].Name == "ActorTreatmentOrderedFor")
                                                    {
                                                        CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                            TreatmentDr);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else if (objJMJMapperTempTreatment.Name == "CompletedBy")
                                    {
                                        objJMJXmlTreatment.InnerText = TreatmentDr[objXmlTreatmentNode.InnerText].ToString();
                                        // Code for creation of Actor Nodes
                                        XmlNodeList JMJXmlActorList = objJMJXmlActors.ChildNodes;
                                        int jCounter = 0;
                                        for (jCounter = 0; jCounter < JMJXmlActorList.Count; jCounter++)
                                        {
                                            if (JMJXmlActorList[jCounter].Attributes["ActorID"].Value == objJMJXmlTreatment.InnerText)
                                            {
                                                ContainsFlag = true;
                                                break;
                                            }
                                        }
                                        if ((ContainsFlag == false) && (jCounter == JMJXmlActorList.Count))
                                        {
                                            for (int iCounter = 0; iCounter < objJMJMapperTempActorList.Count; iCounter++)
                                            {
                                                if (objJMJMapperTempActorList[iCounter].Name == "ActorTreatmentCompletedBy")
                                                {
                                                    CreateActor(objJMJXmlDoc, objJMJXmlActors, objJMJMapperTempActorList[iCounter],
                                                        TreatmentDr);
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        objJMJXmlTreatment.InnerText = TreatmentDr[objXmlTreatmentNode.InnerText].ToString();
                                    }
                                    if (objJMJXmlTreatment.InnerText == "")
                                    {
                                        objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                                    }
                                }
                                // If the condition false, then remove the node
                                else
                                {
                                    objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                                }
                            }
                            else
                            {
                                objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                            }

                        }
                    }
                }
                else if (objJMJMapperTempTreatment.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempTreatment.Attributes.Count > 0)
                    {
                        if (objJMJMapperTempTreatment.Attributes["default"] != null)
                        {
                            if (objJMJMapperTempTreatment.Attributes["default"].Value != "")
                            {
                                objJMJXmlTreatment.InnerText = objJMJMapperTempTreatment.
                                    Attributes["default"].Value;

                            }
                        }
                    }
                    else if (objJMJMapperTempTreatment.Name == "Assessment" && AssessmentID != 0)
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                    }
                    else if (objJMJMapperTempTreatment.InnerText == "" && !objJMJMapperTempTreatment.HasChildNodes)
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                    }

                }
                else if (objJMJMapperTempTreatment.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempTreatment.InnerText == "" && !objJMJMapperTempTreatment.HasChildNodes)
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                    }

                }

                // Conditions to check if the <ObjectID>.<JMJValue> is null then
                // remove <ObjectID> from the parent node
                // objJMJXmlPatient.AppendChild(objJMJXmlTreatment);
                if (objJMJXmlTreatment.Name == "ObjectID")
                {
                    if (objJMJXmlTreatment.SelectSingleNode("JMJValue") == null)
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                    }
                    else if (objJMJXmlTreatment.SelectSingleNode("JMJValue").InnerText == "")
                    {
                        objJMJXmlPatient.RemoveChild(objJMJXmlTreatment);
                    }

                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error in Constitutent Treatment Nodes creation", ex);
            }
        }

        private XmlNode CreatePrimaryContextMessage(XmlDocument JMJComponentDataDoc, XmlNode objJMJXmlActors, XmlDocument objJMJXmlDoc)
        {
            XmlNode objPrimaryContextMessage = null;
            XmlNode objXmlMsgId = null, objXmlMsgSent = null;

            objPrimaryContextMessage = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "Message", null);
            objXmlMsgSent = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "MessageSent", null);
            objXmlMsgSent.InnerText = DateTime.Today.ToShortDateString() + DateTime.Now.ToShortTimeString();
            objPrimaryContextMessage.AppendChild(objXmlMsgSent);

            if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//ID") != null)
            {
                objXmlMsgId = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "MessageID", null);
                objXmlMsgId.InnerText = JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//ID").InnerText;
                objPrimaryContextMessage.AppendChild(objXmlMsgId);
            }
            if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//OrderedFor") != null)
            {
                string ActorIdMsgRecip = JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//OrderedFor").InnerText;
                if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Actors//Actor[@ActorID='" + ActorIdMsgRecip + "']") != null)
                {
                    XmlNode objXmlMsgRecipient = null;
                    XmlNode JMJComponentOrderForAct = JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Actors//Actor[@ActorID='" + ActorIdMsgRecip + "']").Clone();
                    Guid g = new Guid();
                    g = Guid.NewGuid();
                    string strGid = g.ToString().Replace("-", "");
                    JMJComponentOrderForAct.Attributes["ActorID"].Value = strGid;
                    // Copy the node here
                    CopyXmlNode(objJMJXmlDoc, JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Actors//Actor[@ActorID='" + ActorIdMsgRecip + "']").Clone(),
                        objJMJXmlActors, strGid);

                    objXmlMsgRecipient = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "MessageRecipient", null);
                    objXmlMsgRecipient.InnerText = strGid;
                    objPrimaryContextMessage.AppendChild(objXmlMsgRecipient);
                }
            }
            if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//OrderedBy") != null)
            {
                string ActorIdMsgRecip = JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Task//OrderedBy").InnerText;
                if (JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Actors//Actor[@ActorID='" + ActorIdMsgRecip + "']") != null)
                {
                    XmlNode objXmlMsgSender = null;
                    XmlNode JMJComponentOrderForAct = JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Actors//Actor[@ActorID='" + ActorIdMsgRecip + "']").Clone();
                    Guid g = new Guid();
                    g = Guid.NewGuid();
                    string strGid = g.ToString().Replace("-", "");
                    JMJComponentOrderForAct.Attributes["ActorID"].Value = strGid;
                    // Copy the node here
                    CopyXmlNode(objJMJXmlDoc, JMJComponentDataDoc.SelectSingleNode("//JMJComponentData//Actors//Actor[@ActorID='" + ActorIdMsgRecip + "']").Clone(),
                        objJMJXmlActors, strGid);

                    objXmlMsgSender = objJMJXmlDoc.CreateNode(XmlNodeType.Element, "MessageSender", null);
                    objXmlMsgSender.InnerText = strGid;
                    objPrimaryContextMessage.AppendChild(objXmlMsgSender);
                }
            }
            return objPrimaryContextMessage;

        }


        private void CopyXmlNode(XmlDocument objJMJXmlDoc, XmlNode SourceXmlNode,
            XmlNode DestXmlNode, string strGid)
        {

            XmlNode XmlNodeNewNode = null;
            XmlAttribute NewNodeAttrib;
            XmlNodeNewNode = objJMJXmlDoc.CreateNode(XmlNodeType.Element, SourceXmlNode.Name, null);
            DestXmlNode.AppendChild(XmlNodeNewNode);

            // Create code to create Attributes here

            for (int i = 0; i < SourceXmlNode.Attributes.Count; i++)
            {


                NewNodeAttrib = objJMJXmlDoc.CreateAttribute(SourceXmlNode.Attributes[i].Name);
                XmlNodeNewNode.Attributes.Append(NewNodeAttrib);
                if (SourceXmlNode.Attributes[i].Name == "ActorID")
                {
                    NewNodeAttrib.Value = strGid;
                }
                else
                {
                    NewNodeAttrib.Value = SourceXmlNode.Attributes[i].Value;
                }


            }

            //

            if (SourceXmlNode.HasChildNodes && (SourceXmlNode.NodeType == XmlNodeType.Element)
                && SourceXmlNode.FirstChild.NodeType != XmlNodeType.Text)
            {
                foreach (XmlNode SourceXmlChildNode in SourceXmlNode.ChildNodes)
                {
                    // Condition to Check if it contians childnodes
                    if (SourceXmlChildNode.NodeType == XmlNodeType.Element && SourceXmlChildNode.Name != "#text")
                    {
                        CopyXmlNode(objJMJXmlDoc, SourceXmlChildNode, XmlNodeNewNode, strGid);
                    }

                }
                if (!XmlNodeNewNode.HasChildNodes)
                {
                    DestXmlNode.RemoveChild(XmlNodeNewNode);
                }
            }
            // Condition to check if the node is having the mapping then map the values into the 
            // destination node
            else if (SourceXmlNode.HasChildNodes && SourceXmlNode.NodeType == XmlNodeType.Element &&
                SourceXmlNode.FirstChild.NodeType == XmlNodeType.Text)
            {
                if (SourceXmlNode.InnerText != "")
                {
                    XmlNodeNewNode.InnerText = SourceXmlNode.InnerText;
                }
                else
                {
                    DestXmlNode.RemoveChild(XmlNodeNewNode);
                }
            }

                // Conditon to check if the Node doesnt contains any mappings,childnode and attributes 
            else if (!SourceXmlNode.HasChildNodes && SourceXmlNode.InnerText == "")
            {
                DestXmlNode.RemoveChild(XmlNodeNewNode);
            }
        }

        /**************************************************************************************
         *  By: Sumathi									Created: 2/28/2009
         *
         *  Description: This routine constructs the Treatment order(s) under the <Treatment>.<Order>
         *  
         *
         *
         ***************************************************************************************/
        private void CreateTreatmentOrder(XmlDocument objJMJXmlDoc, XmlNode objJMJTreatmentOrder,
            XmlNode objJMJMapperTempTreatmentOrder, DataRow TreatmentOrderDr)
        {
            XmlNode objJMJTreatmentOrderChild = null;
            foreach (XmlNode objXmlTreatmentOrderNode in objJMJMapperTempTreatmentOrder.ChildNodes)
            {
                if (objXmlTreatmentOrderNode.NodeType == XmlNodeType.Element)
                {
                    if (!IsDataRowNull(TreatmentOrderDr, objXmlTreatmentOrderNode.InnerText))
                    {
                        if (TreatmentOrderDr[objXmlTreatmentOrderNode.InnerText] != System.DBNull.Value)
                        {
                            objJMJTreatmentOrderChild = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlTreatmentOrderNode.Name, null);
                            objJMJTreatmentOrder.AppendChild(objJMJTreatmentOrderChild);
                            objJMJTreatmentOrderChild.InnerText = TreatmentOrderDr[objXmlTreatmentOrderNode.InnerText].ToString();
                        }
                    }

                }
            }
        }
        /**************************************************************************************
         *  By: Nithin									Created: 
         *
         *  Description: This routine constructs the Treatment Note(s) 
         *  
         *
         *
         ***************************************************************************************/

        private void CreateTreatmentNote(XmlDocument objJMJXmlDoc, XmlNode objJMJTreatmentNote,
            XmlNode objJMJMapperTempTreatmentNote, DataRow TreatmentNoteDr)
        {
            XmlNode objJMJTreatmentNoteChild = null;
            foreach (XmlNode objXmlTreatmentNoteNode in objJMJMapperTempTreatmentNote.ChildNodes)
            {
                if (objXmlTreatmentNoteNode.NodeType == XmlNodeType.Element)
                {
                    if (!IsDataRowNull(TreatmentNoteDr, objXmlTreatmentNoteNode.InnerText))//// check to see the progress_value column has value
                    {
                        if (TreatmentNoteDr[objXmlTreatmentNoteNode.InnerText] != System.DBNull.Value)
                        {
                            objJMJTreatmentNoteChild = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlTreatmentNoteNode.Name, null);
                            objJMJTreatmentNote.AppendChild(objJMJTreatmentNoteChild);
                            objJMJTreatmentNoteChild.InnerText = TreatmentNoteDr[objXmlTreatmentNoteNode.InnerText].ToString();
                        }
                        else if (!IsDataRowNull(TreatmentNoteDr, "progress")) // check to see the progress column has value
                        {
                            if (TreatmentNoteDr["progress"] != System.DBNull.Value)
                            {
                                objJMJTreatmentNoteChild = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlTreatmentNoteNode.Name, null);
                                objJMJTreatmentNote.AppendChild(objJMJTreatmentNoteChild);
                                objJMJTreatmentNoteChild.InnerText = TreatmentNoteDr["progress"].ToString();
                            }
                        }
                    }

                }
            }
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of 
        * TreatmentMedication nodes.
        * 
        * Description: 
        * This routine returns TreatmentMedication Data.
        *
        * ********************************************************************/

        private void CreateTreatmentMedication(XmlDocument objJMJXmlDoc, XmlNode objJMJXmlPatient,
            XmlNode objJMJXmlTreatment, XmlNode objJMJMapperTempTrMedication,
            DataRow TreatmentMedicationDr, string TreatmentId)
        {
            try
            {
                XmlNode objJMJXmlTreatMedication = null;
                objJMJXmlTreatMedication = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objJMJMapperTempTrMedication.Name, null);
                objJMJXmlTreatment.AppendChild(objJMJXmlTreatMedication);


                if (objJMJMapperTempTrMedication.ChildNodes.Count > 0 &&
                    objJMJMapperTempTrMedication.NodeType == XmlNodeType.Element)
                {
                    foreach (XmlNode objXmlTrMedicationNode in objJMJMapperTempTrMedication.ChildNodes)
                    {
                        if (objXmlTrMedicationNode.NodeType == XmlNodeType.Element)
                        {
                            CreateTreatmentMedication(objJMJXmlDoc, objJMJXmlPatient, objJMJXmlTreatMedication,
                                objXmlTrMedicationNode, TreatmentMedicationDr, TreatmentId);
                        }
                        else if (objXmlTrMedicationNode.NodeType == XmlNodeType.Text
                            && objXmlTrMedicationNode.Name == "#text")
                        {

                            if (!IsDataRowNull(TreatmentMedicationDr, objXmlTrMedicationNode.InnerText))
                            {
                                // Condition to check Check for null values in the datarow
                                // If condition true , then set the node text
                                if (TreatmentMedicationDr[objXmlTrMedicationNode.InnerText] != System.DBNull.Value)
                                {
                                    if (objJMJMapperTempTrMedication.Name == "ExpirationDate")
                                    {
                                        objJMJXmlTreatMedication.InnerText = Convert.ToDateTime(TreatmentMedicationDr[objXmlTrMedicationNode.InnerText]
                                            .ToString()).ToString("u");
                                    }
                                    else
                                    {
                                        objJMJXmlTreatMedication.InnerText = TreatmentMedicationDr[objXmlTrMedicationNode.InnerText].ToString();
                                    }
                                }
                                // If the condition false, then remove the node
                                else
                                {
                                    objJMJXmlTreatment.RemoveChild(objJMJXmlTreatMedication);
                                }
                            }
                            else if ((objJMJMapperTempTrMedication.InnerText == "Admin Instructions" || objJMJMapperTempTrMedication.InnerText == "Dosing Instructions" ||
                                objJMJMapperTempTrMedication.InnerText == "Pharmacist Instructions" || objJMJMapperTempTrMedication.InnerText == "Patient Instructions"))
                            {
                                string CondStr = "//JMJDocument//PatientRecord//Treatment[@TreatmentID='" + TreatmentId + "']//TreatmentNote[NoteKey='" +
                                    objJMJMapperTempTrMedication.InnerText + "']//NoteText";
                                if (objJMJXmlPatient.SelectSingleNode("//JMJDocument//PatientRecord//Treatment[@TreatmentID='" + TreatmentId + "']//TreatmentNote[NoteKey='" + objJMJMapperTempTrMedication.InnerText + "']") != null)
                                {
                                    if (objJMJXmlPatient.SelectSingleNode(CondStr) != null && objJMJXmlPatient.SelectSingleNode(CondStr).InnerText != null)
                                    {
                                        objJMJXmlTreatMedication.InnerText = objJMJXmlPatient.SelectSingleNode(CondStr).InnerText;
                                    }
                                    else
                                    {
                                        objJMJXmlTreatment.RemoveChild(objJMJXmlTreatMedication);
                                    }
                                }
                                else
                                    objJMJXmlTreatment.RemoveChild(objJMJXmlTreatMedication);
                            }

                            else if (objJMJMapperTempTrMedication.InnerText == "" && !objJMJMapperTempTrMedication.HasChildNodes)
                            {
                                objJMJXmlTreatment.RemoveChild(objJMJXmlTreatMedication);
                            }

                        }
                    }
                }
                else if (objJMJMapperTempTrMedication.NodeType == XmlNodeType.Element)
                {
                    if (objJMJMapperTempTrMedication.InnerText == "" && !objJMJMapperTempTrMedication.HasChildNodes)
                    {
                        objJMJXmlTreatment.RemoveChild(objJMJXmlTreatMedication);
                    }

                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error in Treatment Medication Nodes creation", ex);
            }
        }

        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of 
        * Observation and ObservationResult nodes of Treatment Node
        * 
        * Description: 
        * This routine returns Observation and ObservationResult nodes. This 
        * is called while the creation of Treatment Nodes
        *
        * ********************************************************************/
        private void CreateObservation(XmlDocument objJMJXmlDoc, XmlNode objJMJXmlTreatment,
            XmlNode objXmlMapperObxNode, DataRow TreatmentDr, DataSet TreatmentObxDs, DataSet TreatmentObxNoteDs)
        {
            try
            {
                DataRow TreatmentObxDr = null;
                for (int iObxCounter = 0; iObxCounter < TreatmentObxDs.Tables[0].Rows.Count; iObxCounter++)
                {
                    TreatmentObxDr = TreatmentObxDs.Tables[0].Rows[iObxCounter];
                    if (!IsDataRowNull(TreatmentObxDr, "record_type") && !IsDataRowNull(TreatmentObxDr, "observation_id") &&
                        TreatmentObxDr["record_type"] != System.DBNull.Value && TreatmentObxDr["observation_id"] != System.DBNull.Value)
                    {
                        // Create Observation Node
                        if (TreatmentObxDr["record_type"].ToString() == "Root" &&
                            TreatmentObxDr["observation_id"].ToString() == TreatmentDr["observationid"].ToString())
                        {
                            CreateObservationChildNode(objJMJXmlDoc, objJMJXmlTreatment,
                                objXmlMapperObxNode, TreatmentObxDr, TreatmentObxDs, TreatmentObxNoteDs);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error in Observation Nodes creation", ex);
            }
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the creation of 
        * Observation Child nodes and ObservationNote Nodes
        * 
        * Description: 
        * This routine returns Observation child nodes 
        *
        * ********************************************************************/
        private void CreateObservationChildNode(XmlDocument objJMJXmlDoc, XmlNode objJMJXmlObservation,
            XmlNode objXmlMapperTempObx, DataRow TreatmentObxDr, DataSet TreatmentObxDs, DataSet TreatmentObxNoteDs)
        {
            XmlNode objJMJXmlTreatmentObx = null;
            objJMJXmlTreatmentObx = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlMapperTempObx.Name, null);
            objJMJXmlObservation.AppendChild(objJMJXmlTreatmentObx);

            if (objXmlMapperTempObx.ChildNodes.Count > 0 &&
                objXmlMapperTempObx.NodeType == XmlNodeType.Element)
            {
                foreach (XmlNode objXmlObxNode in objXmlMapperTempObx.ChildNodes)
                {
                    if (objXmlObxNode.NodeType == XmlNodeType.Element &&
                        objXmlObxNode.Name == "ObservationNote")
                    {
                        DataRow TreatmentObxNoteDr = null;
                        for (int iObxNote = 0; iObxNote < TreatmentObxNoteDs.Tables[0].Rows.Count; iObxNote++)
                        {
                            TreatmentObxNoteDr = TreatmentObxNoteDs.Tables[0].Rows[iObxNote];
                            XmlNode objJMJTreatmentObxNote = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlObxNode.Name, null);
                            objJMJXmlTreatmentObx.AppendChild(objJMJTreatmentObxNote);
                            CreateTreatmentObxNote(objJMJXmlDoc, objJMJTreatmentObxNote,
                                objXmlObxNode, TreatmentObxNoteDr);

                        }

                    }
                    else if (objXmlObxNode.NodeType == XmlNodeType.Element && objXmlObxNode.Name != "ObservationResult" &&
                        objXmlObxNode.Name != "Observation")
                    {
                        CreateObservationChildNode(objJMJXmlDoc, objJMJXmlTreatmentObx,
                            objXmlObxNode, TreatmentObxDr, TreatmentObxDs, TreatmentObxNoteDs);
                    }

                    else if (objXmlObxNode.NodeType == XmlNodeType.Element && objXmlObxNode.Name == "ObservationResult" &&
                        objXmlObxNode.Name != "Observation")
                    {
                        DataRow ObxResultDr = null;
                        for (int iObxCounter = 0; iObxCounter < TreatmentObxDs.Tables[0].Rows.Count; iObxCounter++)
                        {
                            ObxResultDr = TreatmentObxDs.Tables[0].Rows[iObxCounter];
                            if (TreatmentObxDr["history_sequence"].ToString() == ObxResultDr["parent_history_sequence"].ToString() &&
                                ObxResultDr["record_type"].ToString() == "Result")
                            {
                                // Create ObservationResult Node
                                CreateObservationChildNode(objJMJXmlDoc, objJMJXmlTreatmentObx,
                                    objXmlObxNode, ObxResultDr, TreatmentObxDs, TreatmentObxNoteDs);
                            }
                        }
                    }
                    else if (objXmlObxNode.NodeType == XmlNodeType.Element && objXmlObxNode.Name != "ObservationResult" &&
                        objXmlObxNode.Name == "Observation")
                    {
                        DataRow InnerObxDr = null;
                        for (int iObxCounter = 0; iObxCounter < TreatmentObxDs.Tables[0].Rows.Count; iObxCounter++)
                        {
                            InnerObxDr = TreatmentObxDs.Tables[0].Rows[iObxCounter];
                            if (TreatmentObxDr["history_sequence"].ToString() == InnerObxDr["parent_history_sequence"].ToString() &&
                                InnerObxDr["record_type"].ToString() == "Observation")
                            {
                                // Create the Inner Observation Node
                                CreateObservationChildNode(objJMJXmlDoc, objJMJXmlTreatmentObx,
                                    objXmlObxNode, InnerObxDr, TreatmentObxDs, TreatmentObxNoteDs);

                            }
                        }


                    }

                    else if (objXmlObxNode.NodeType == XmlNodeType.Text
                        && objXmlObxNode.Name == "#text")
                    {

                        if (!IsDataRowNull(TreatmentObxDr, objXmlObxNode.InnerText))
                        {
                            // Condition to check Check for null values in the datarow
                            // If condition true , then set the node text
                            if (TreatmentObxDr[objXmlObxNode.InnerText] != System.DBNull.Value)
                            {
                                if (TreatmentObxDr[objXmlObxNode.InnerText].ToString() != "NULL")
                                {
                                    if (objXmlMapperTempObx.Name == "ResultDate" ||
                                        objXmlMapperTempObx.Name == "ResultExpectedDate")
                                    {
                                        objJMJXmlTreatmentObx.InnerText = Convert.ToDateTime(TreatmentObxDr[objXmlObxNode.InnerText]
                                            .ToString()).ToString("u");
                                    }
                                    else
                                    {
                                        objJMJXmlTreatmentObx.InnerText = TreatmentObxDr[objXmlObxNode.InnerText].ToString();
                                    }
                                }
                                else
                                {
                                    objJMJXmlObservation.RemoveChild(objJMJXmlTreatmentObx);
                                }
                            }
                            // If the condition false, then remove the node
                            else
                            {
                                objJMJXmlObservation.RemoveChild(objJMJXmlTreatmentObx);
                            }
                        }

                    }
                }
            }
            else if (objXmlMapperTempObx.NodeType == XmlNodeType.Element)
            {
                if (objXmlMapperTempObx.Attributes.Count > 0)
                {
                    if (objXmlMapperTempObx.Attributes["default"] != null)
                    {
                        if (objXmlMapperTempObx.Attributes["default"].Value != "")
                        {
                            objJMJXmlTreatmentObx.InnerText = objXmlMapperTempObx.
                                Attributes["default"].Value;
                        }
                    }
                }
                else if (objXmlMapperTempObx.InnerText == "" && !objXmlMapperTempObx.HasChildNodes)
                {
                    objJMJXmlObservation.RemoveChild(objJMJXmlTreatmentObx);
                }
            }
            else if (objXmlMapperTempObx.NodeType == XmlNodeType.Element)
            {
                if (objXmlMapperTempObx.InnerText == "" && !objXmlMapperTempObx.HasChildNodes)
                {
                    objJMJXmlObservation.RemoveChild(objJMJXmlTreatmentObx);
                }
            }
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is called for the ObservationNote Nodes
        * 
        * Description: 
        * This routine returns ObservationNote nodes 
        *
        * ********************************************************************/
        private void CreateTreatmentObxNote(XmlDocument objJMJXmlDoc, XmlNode objJMJXmlObxNode,
            XmlNode objXmlMapperTempObxNote, DataRow TreatmentObxNoteDr)
        {
            XmlNode objJMJTreatmentObxNoteChild = null;
            foreach (XmlNode objXmlTreatmentObxNoteNode in objXmlMapperTempObxNote.ChildNodes)
            {
                if (objXmlTreatmentObxNoteNode.NodeType == XmlNodeType.Element)
                {
                    if (!IsDataRowNull(TreatmentObxNoteDr, objXmlTreatmentObxNoteNode.InnerText))
                    {
                        if (TreatmentObxNoteDr[objXmlTreatmentObxNoteNode.InnerText] != System.DBNull.Value)
                        {
                            objJMJTreatmentObxNoteChild = objJMJXmlDoc.CreateNode(XmlNodeType.Element, objXmlTreatmentObxNoteNode.Name, null);
                            objJMJXmlObxNode.AppendChild(objJMJTreatmentObxNoteChild);
                            objJMJTreatmentObxNoteChild.InnerText = TreatmentObxNoteDr[objXmlTreatmentObxNoteNode.InnerText].ToString();
                        }
                    }
                }
            }
        }
        /********************************************************************* 
        * 
        * By: Nitin Vikraman                  Date: 24-05-2007
        * 
        * Purpose: This function is to check whether the Column Exist in DataRow
        * 
        * Description: 
        * This routine returns True if column doesnt exist in the DataRow.
        *
        * ********************************************************************/
        private bool IsDataRowNull(DataRow dr, string ColumnName)
        {

            try
            {
                string str = null;
                str = dr[ColumnName].ToString();
                // sumathi added 3/5/2009
                if (str == null || str == "")
                    return true;
                return false;

            }
            catch (Exception ex)
            {
                Console.Write(ex.StackTrace);
                return true;
            }
        }
        private bool IsNodeNull(XmlNode Node)
        {
            try
            {
                if (Node == null)
                {
                    return true;
                }
                else if (Node.InnerText == "")
                {
                    return true;
                }
                else
                    return false;
            }
            catch (Exception ex)
            {
                Console.Write(ex.Message);
                return true;
            }
        }

        /*********************************************************************
         * 
         * By: Sumathi Chinnasamy			Date: 4-26-2007
         * This routine returns the progress notes based on the context object
         * 
         * ******************************************************************/
        private DataSet getProgress(string cprId, string contextObject, int objectKey, string progType, string progKey, string atchFlag)
        {
            System.Data.SqlClient.SqlParameter[] NoteDsParams = new System.Data.SqlClient.SqlParameter[6];
            NoteDsParams[0] = new SqlParameter("@ps_cpr_id", SqlDbType.VarChar);
            NoteDsParams[0].Value = cprId;
            NoteDsParams[1] = new SqlParameter("@ps_context_object", SqlDbType.VarChar);
            NoteDsParams[1].Value = contextObject;
            NoteDsParams[2] = new SqlParameter("@pl_object_key", SqlDbType.Int);
            NoteDsParams[2].Value = objectKey;
            NoteDsParams[3] = new SqlParameter("@ps_progress_type", SqlDbType.VarChar);
            NoteDsParams[3].Value = System.DBNull.Value;
            NoteDsParams[4] = new SqlParameter("@ps_progress_key", SqlDbType.VarChar);
            NoteDsParams[4].Value = System.DBNull.Value;
            NoteDsParams[5] = new SqlParameter("@ps_attachment_only_flag", SqlDbType.VarChar);
            NoteDsParams[5].Value = System.DBNull.Value;

            return base.ExecuteSql("exec dbo.jmjdoc_get_progress @ps_cpr_id,@ps_context_object,@pl_object_key,@ps_progress_type,@ps_progress_key,@ps_attachment_only_flag", ref NoteDsParams);


        }



    }
}
