# Print a PDF From C#

Recently, a colleague of mine was wondering how to print a PDF file to a specified print queue from a .NET application.  This is what I came up with as a solution

    #csharp
    /// <summary>
    /// Prints a PDF file to the specified printer using Adobe Reader.
    /// Tested with Adobe Reader XI, but should work with any recent version.
    /// The registry path might be different on a 64-bit system.
    /// </summary>
    /// <param name="PdfFile">path to the PDF file to print</param>
    /// <param name="PrinterName">name of the print queue</param>
    /// <returns>true if no exception</returns>
    static bool PrintPdf(string PdfFile, string PrinterName) {
    
        // our not successful yet
        bool success = false;
    
        // registry path that will lead us to the Reader executable
        string RegKey = @"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\AcroRd32.exe";
    
        try {
            // open up adobe reader with the right command line
            System.Diagnostics.Process.Start(
                Microsoft.Win32.Registry.LocalMachine.OpenSubKey(RegKey).GetValue("", "").ToString(),
                string.Format("/s /h /t \"{0}\" \"{1}\"", PdfFile, PrinterName));
    
            // we are successful
            return true;
        } catch (Exception e) {
            // log the exception here if you want
            Console.Error.WriteLine("Ran into a problem: " + e.Message);
            Console.Error.WriteLine(e.StackTrace);
        }
    
        // return our success value
        return success;
    }
    
