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
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EncounterPRO.OS
{
    [ClassInterface(ClassInterfaceType.AutoDual)]
    public class ImageManipulation
    {

        public int LogEvent(string objectName, string scriptName, string message, int severity)
        {
            EventLog eventLog = new EventLog("Application", ".", "EPImageControl");

            if (null == eventLog)
            {
                eventLog = new EventLog("Application", ".", "EncounterPRO");
                eventLog.WriteEntry("EncounterPRO Event Logging initialized automatically because it was not initialized by the caller.", EventLogEntryType.Warning);
            }
            try
            {
                EventLogEntryType eventSeverity = EventLogEntryType.Information;
                if (null == objectName)
                {
                    objectName = "UnknownObject";
                }
                if (null == scriptName)
                {
                    scriptName = "UnknownScript";
                }
                if (null == message)
                {
                    message = "UnknownMessage";
                }
                switch (severity)
                {
                    case 1:
                    case 2:
                        eventSeverity = EventLogEntryType.Information;
                        break;
                    case 3:
                        eventSeverity = EventLogEntryType.Warning;
                        break;
                    case 4:
                    case 5:
                        eventSeverity = EventLogEntryType.Error;
                        break;
                }

                eventLog.WriteEntry(Environment.UserDomainName + "\\" + Environment.UserName + " on " + Environment.MachineName + "\r\n" + System.Windows.Forms.Application.ProductVersion + " >>> " + objectName + " - (" + scriptName + ") " + message, eventSeverity);
                return 1;
            }
            catch (Exception)
            {
                return -1;
            }
            finally
            {
                eventLog.Close();
            }

        }

        public void GetImageSize(string sourceFile, out int width, out int height)
        {
            Image bmpSource = null;
            try
            {
                bmpSource = Image.FromFile(sourceFile, true);
                width = (int)(((float)bmpSource.Width * 1000) / bmpSource.HorizontalResolution);
                height = (int)(((float)bmpSource.Height * 1000) / bmpSource.VerticalResolution);
                return;
            }
            catch (Exception exc)
            {
                LogEvent(exc.Source, exc.TargetSite.Name, "Error getting image size\r\n\r\n" + exc.ToString(), 2);
                width = -1;
                height = -1;
                return;
            }
            finally
            {
                try
                {
                    bmpSource.Dispose();
                }
                catch { }
            }
        }
        public void GetImageInfo(string sourceFile, out int width, out int height, out int hResolution, out int vResolution)
        {
            Image bmpSource = null;
            try
            {
                bmpSource = Image.FromFile(sourceFile, true);
                width = bmpSource.Width;
                height = bmpSource.Height;
                hResolution = (int)bmpSource.HorizontalResolution;
                vResolution = (int)bmpSource.VerticalResolution;
                return;
            }
            catch (Exception exc)
            {
                LogEvent(exc.Source, exc.TargetSite.Name, "Error getting image size\r\n\r\n" + exc.ToString(), 2);
                width = -1;
                height = -1;
                hResolution = -1;
                vResolution = -1;
                return;
            }
            finally
            {
                try
                {
                    bmpSource.Dispose();
                }
                catch { }
            }
        }
        public void GetImageSizePixels(string sourceFile, out int width, out int height)
        {
            Image bmpSource = null;
            try
            {
                bmpSource = Image.FromFile(sourceFile, true);
                width = bmpSource.Width;
                height = bmpSource.Height;
                return;
            }
            catch (Exception exc)
            {
                LogEvent(exc.Source, exc.TargetSite.Name, "Error getting image size\r\n\r\n" + exc.ToString(), 2);
                width = -1;
                height = -1;
                return;
            }
            finally
            {
                try
                {
                    bmpSource.Dispose();
                }
                catch { }
            }
        }
        public int ConvertTo1bppBmp(string sourceFile, string outputFile)
        {
            try
            {
                Image bmpSource = Image.FromFile(sourceFile, true);
                int luminanceCutoff = 250;

                Image bmpOutput = new Bitmap(bmpSource.Width, bmpSource.Height);
                Graphics gfx = Graphics.FromImage(bmpOutput);

                gfx.DrawImage(bmpSource, new Rectangle(0, 0, bmpOutput.Width, bmpOutput.Height), 0, 0, bmpSource.Width, bmpSource.Height, GraphicsUnit.Pixel);
                bmpOutput = ConvertTo1bppIndexed((Bitmap)bmpOutput, luminanceCutoff);

                if (System.IO.File.Exists(outputFile))
                {
                    System.IO.File.Delete(outputFile);
                }

                bmpOutput.Save(outputFile, ImageFormat.Bmp);
            }
            catch (Exception exc)
            {
                LogEvent(exc.Source, exc.TargetSite.Name, "Error converting image to 1bpp\r\n\r\n" + exc.ToString(), 4);
                return -1;
            }
            return 1;
        }

        public int ResizeDarkenBitmap(string sourceFile, string outputFile, int outputWidth, int outputHeight, int luminanceCutoff)
        {
            try
            {
                Image bmpSource = Image.FromFile(sourceFile, true);

                int widthZoom = (outputWidth * 100) / bmpSource.Width;
                int heightZoom = (outputHeight * 100) / bmpSource.Height;

                int outputZoom = widthZoom > heightZoom ? widthZoom : heightZoom;

                Image bmpOutput = new Bitmap((bmpSource.Width * outputZoom) / 100, (bmpSource.Height * outputZoom) / 100);
                Graphics gfx = Graphics.FromImage(bmpOutput);

                gfx.PixelOffsetMode = PixelOffsetMode.HighQuality;
                gfx.SmoothingMode = SmoothingMode.HighQuality;
                gfx.InterpolationMode = InterpolationMode.High;
                gfx.DrawImage(bmpSource, new Rectangle(0, 0, bmpOutput.Width, bmpOutput.Height), 0, 0, bmpSource.Width, bmpSource.Height, GraphicsUnit.Pixel);
                bmpOutput = ConvertTo1bppIndexed((Bitmap)bmpOutput, luminanceCutoff);

                if (System.IO.File.Exists(outputFile))
                {
                    System.IO.File.Delete(outputFile);
                }

                bmpOutput.Save(outputFile, ImageFormat.Bmp);
            }
            catch (Exception exc)
            {
                LogEvent(exc.Source, exc.TargetSite.Name, "Error in ResizeDarkenBitmap()\r\n\r\n" + exc.ToString(), 4);
                return -1;
            }
            return 1;
        }

        internal static Bitmap ConvertTo1bppIndexed(Bitmap src)
        {
            return ConvertTo1bppIndexed(src, 128);
        }
        internal static Bitmap ConvertTo1bppIndexed(Bitmap src, int luminanceCutOff)
        {
            int width, height;
            Bitmap dest;
            Rectangle rect;
            BitmapData data;
            IntPtr pixels;
            uint row, col;

            //Collect SOURCE Bitmap info
            width = src.Width;
            height = src.Height;

            //Create the DESTINATION Bitmap
            dest = new Bitmap(width, height, PixelFormat.Format1bppIndexed);
            dest.SetResolution(src.HorizontalResolution, src.VerticalResolution);

            //LOCK the Entire Bitmap & get the pixel pointer
            rect = new Rectangle(0, 0, width, height);
            data = dest.LockBits(rect, ImageLockMode.WriteOnly,
                PixelFormat.Format1bppIndexed);
            pixels = data.Scan0;

            unsafe
            {
                Color srcPixel;
                byte* pBits, pDestPixel;
                byte bMask;
                double luminance;

                //Init pointer to the Bits
                if (data.Stride > 0) pBits = (byte*)pixels.ToPointer();
                else pBits = (byte*)pixels.ToPointer() + data.Stride * (height -
                         1);

                //Stride could be negative
                uint stride = (uint)Math.Abs(data.Stride);

                //Go through all the Pixels in the rectangle
                for (row = 0; row < height; row++)
                {
                    for (col = 0; col < width; col++)
                    {
                        //Get the Pixel from the SOURCE
                        srcPixel = src.GetPixel((int)col, (int)row);
                        //srcPixel = Color.White;

                        //Move the DESTINATION to the correct Address / Pointer & get Pixel
                        pDestPixel = pBits + (row * stride) + ((int)(col / 8));

                        //Determine which Bit Represents this Pixel in 1bpp format
                        bMask = (byte)(0x0080 >> (int)(col % 8));

                        //Calculate LUMINANCE to help determine if black or white pixel
                        luminance = (srcPixel.R * 0.299) + (srcPixel.G * 0.587) + (srcPixel.B
                            * 0.114);

                        //Set to Black or White using the Color. Luminance Cut Off
                        if (luminance >= luminanceCutOff)
                            *pDestPixel |= (byte)bMask;        // Set Bit to 1    - White
                        else
                            *pDestPixel &= (byte)~bMask;        // Set Bit to 0 - Black
                    }
                }

            }
            dest.UnlockBits(data);
            return dest;
        }
    }
}
