﻿-- Revise to replace the whole table


-- Assume if first and last ones are not present, all have not yet been inserted.
IF NOT EXISTS (SELECT 1 FROM [c_Synonym] 
	WHERE [term] = 'diphtheria toxoid (d)'
	AND [term_type] = 'drug_ingredient'
	AND [alternate] = 'diphtheria toxoid vaccine, inactivated'
	)
	AND NOT EXISTS (SELECT 1 FROM [c_Synonym] 
	WHERE [term] = 'calcipotriol'
	AND [term_type] = 'drug_ingredient'
	AND [alternate] = 'calcipotriene'
	)
BEGIN 		
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('5 Lf tetanus toxoid (T)','drug_ingredient','tetanus toxoid vaccine, inactivated 10 UNT/ML Injection')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('5 mcg filamentous hemagglutinin (FHA)','drug_ingredient','Bordetella pertussis filamentous hemagglutinin vaccine, inactivated 0.01 MG/ML')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Acellular Pertussis Filamentous Haemagglutinin (FHA)','drug_ingredient','Bordetella pertussis filamentous hemagglutinin vaccine, inactivated')				
 	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('acetaminophen','drug_ingredient','paracetamol')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Adrenalin','drug_ingredient','Epinephrine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Adrenaline','drug_ingredient','Epinephrine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('AliminUM','drug_ingredient','AluminIUM')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Aminosidine','drug_ingredient','Paromomycin')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('amLODIPine','drug_ingredient','Amlodipine Besylate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Anastrazole','drug_ingredient','Anastrozole')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Anastrozol','drug_ingredient','Anastrozole')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Atracurium Besilate','drug_ingredient','Atracurium Besylate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Atropine Sulphate','drug_ingredient','Atropine Sulfate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('benzylpenicillin','drug_ingredient','Penicillin G benzathine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Benzathine Penicillin','drug_ingredient','Penicillin G benzathine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('benzhexol','drug_ingredient','Trihexyphenidyl')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Benzoyl metronidazole','drug_ingredient','Metronidazole Benzoate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Benzoylmetronidazole','drug_ingredient','Metronidazole Benzoate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Benzoylmetronildazole','drug_ingredient','Metronidazole Benzoate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Benzyl Penicillin','drug_ingredient','Penicillin G')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Benzylpenicillin Potassium','drug_ingredient','Penicillin G Potassium')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Benzylpenicillin Sodium','drug_ingredient','Penicillin G Sodium')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('butylscopolamine bromide','drug_ingredient','Hyoscine Butylbromide')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('calcipotriol','drug_ingredient','calcipotriene')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Carbocisteine','drug_ingredient','Carbocysteine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Cephalexin','drug_ingredient','Cefalexin')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Chlorphenamine','drug_ingredient','Chlorpheniramine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Chlortenoxicam','drug_ingredient','Lornoxicam')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Choriogonadotropin','drug_ingredient','Chorionic gonadotropin')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Chorionic gonadotropHin','drug_ingredient','Chorionic gonadotropin')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Ciclosporin','drug_ingredient','Cyclosporine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Cinchocaine','drug_ingredient','dibucaine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Clavulanic Acid','drug_ingredient','Clavulanate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Clomifene Citrate','drug_ingredient','Clomiphene Citrate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Clomifene','drug_ingredient','Clomiphene')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Clozapin','drug_ingredient','Clozapine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Colecalciferol','drug_ingredient','Cholecalciferol')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Crystalline Protamine Insulin','drug_ingredient','NPH (Neutral Protamine Hagedorn) Insulin')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Cyanocobalamin','drug_ingredient','Vitamin B12')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Cyclosporin','drug_ingredient','Cyclosporine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('diacerein','drug_ingredient','Diacetylrhein')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('dicycloverine','drug_ingredient','dicyclomine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Dihydrocodeine tartrate','drug_ingredient','Dihydrocodeine bitartrate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Dimethicone','drug_ingredient','Dimeticone')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('diphtheria toxoid (d)','drug_ingredient','diphtheria toxoid vaccine, inactivated')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Doxofylline','drug_ingredient','doxophylline')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Drotaverine','drug_ingredient','Drotaverin')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('erythropoetin','drug_ingredient','Epoetin alfa')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('erythropoietin','drug_ingredient','Epoetin alfa')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Etamsylate','drug_ingredient','Ethamsylate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Etophylline','drug_ingredient','Etofylline')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('filamentous haemagglutinin','drug_ingredient','Bordetella pertussis filamentous hemagglutinin vaccine, inactivated')			
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Flucloxacillin','drug_ingredient','Floxacillin')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('flumethasone pivalate','drug_ingredient','Flumetasone pivalate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Flupentixol','drug_ingredient','Flupenthixol')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Frusemide','drug_ingredient','Furosemide')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Glibenclamide','drug_ingredient','Glyburide')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Guaiphenesin','drug_ingredient','Guaifenesin')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Hydroxycarbamide','drug_ingredient','Hydroxyurea')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Hyoscine-N-Butylbromide','drug_ingredient','Hyoscine Butylbromide')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Ibandronic Acid','drug_ingredient','Ibandronate Sodium')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Inactivated poliomyelitis Vaccine Type 1 (Mahoney)','drug_ingredient','Poliovirus inactivated-Type 1 (Mahoney)')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Inactivated poliomyelitis Vaccine Type 2 (MEF-1)','drug_ingredient','Poliovirus Inactivated- Type 2 (MEF-1)')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('inactivated poliovirus type 1 (Mahoney)','drug_ingredient','Poliovirus inactivated-Type 1 (Mahoney)')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('inactivated poliovirus type 2 (MEF-1)','drug_ingredient','Poliovirus Inactivated- Type 2 (MEF-1)')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('inactivated poliovirus type 3 (Saukett)','drug_ingredient','Poliovirus Inactivated-Type 3 (Saukett)')
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('interferon beta 1a','drug_ingredient','interferon beta-1a')
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('iron sucrose','drug_ingredient','ferric sucrose')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Isophane Insulin','drug_ingredient','NPH (Neutral Protamine Hagedorn) Insulin')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Levocetirizine dihydrochloride','drug_ingredient','Levocetirizine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('levosalbutamol','drug_ingredient','Levalbuterol')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Lignocaine','drug_ingredient','Lidocaine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Losartan','drug_ingredient','Losartan Potassium')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('meclozine','drug_ingredient','meclizine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Menotrophins','drug_ingredient','Menotropins')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Mesalazine','drug_ingredient','Mesalamine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('methyl sulfonyl methane','drug_ingredient','Methylsulphonylmethane')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('methyl sulphonyl methane','drug_ingredient','Methylsulphonylmethane')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('methylcobalamin','drug_ingredient','Mecobalamin')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Mycofenolate Mofetil','drug_ingredient','Mycophenolate Mofetil')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Neostigmine Metilsulfate','drug_ingredient','Neostigmine Methylsulfate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Nicotinamide','drug_ingredient','Niacinamide')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Nicotinic Acid Amide','drug_ingredient','Niacinamide')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Nonoxinol-9','drug_ingredient','Nonoxynol-9')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Norethisterone acetate','drug_ingredient','Norethindrone acetate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Oxybutynin Hydrochloride','drug_ingredient','Oxybutynin Chloride')				
 	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('paracetamol','drug_ingredient','acetaminophen')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Penicillin V','drug_ingredient','Penicillin V Potassium')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Pethidine','drug_ingredient','Meperidine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Phenobarb','drug_ingredient','Phenobarbital')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Phenobarbitone','drug_ingredient','Phenobarbital')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Phenoxymethyl Penicillin','drug_ingredient','Penicillin V Potassium')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Phenoxymethylpenicillin','drug_ingredient','Penicillin V')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Phylloquinone','drug_ingredient','Vitamin K1')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Phytomenadione','drug_ingredient','Vitamin K1')
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('phytonadione','drug_ingredient','Vitamin K1')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Polymixin','drug_ingredient','Polymyxin')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Potassium Clavulanate','drug_ingredient','Clavulanate')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Procaine benzylpenicillin','drug_ingredient','Penicillin G Procaine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Procaine Penicillin G','drug_ingredient','Penicillin G Procaine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Procaine Penicillin','drug_ingredient','Penicillin G Procaine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('rifampin','drug_ingredient','Rifampicin')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('salbutamol','drug_ingredient','albuterol')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Scopolamine butylbromide','drug_ingredient','Hyoscine Butylbromide')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Simeticone','drug_ingredient','Simethicone')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Sodium Benzylpenicillin','drug_ingredient','Penicillin G Sodium')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Sodium Penicillin G','drug_ingredient','Penicillin G Sodium')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Sulfamethopyrazine','drug_ingredient','Sulfalene')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Sulfamethoxypyrazine','drug_ingredient','Sulfalene')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Sulfametopyrazine','drug_ingredient','Sulfalene')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Sulphalene','drug_ingredient','Sulfalene')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Sulphametopyrazine','drug_ingredient','Sulfalene')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('thiamin','drug_ingredient','Thiamine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Thiopentone','drug_ingredient','Thiopental')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Torasemide','drug_ingredient','Torsemide')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Tribavirin','drug_ingredient','Ribavirin')			
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Ursodeoxycholic acid','drug_ingredient','Ursodiol')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Vaginal Suppository','drug_ingredient','Vaginal Pessary')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Valgancyclovir HCl','drug_ingredient','valGANciclovir HCl')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Vitamin B1','drug_ingredient','Thiamine')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('vitamin B3','drug_ingredient','Niacinamide')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Vitamin C','drug_ingredient','Ascorbic Acid')				
	INSERT INTO [dbo].[c_Synonym]([term],[term_type],[alternate]) VALUES ('Vitamin D3','drug_ingredient','Cholecalciferol')				
END