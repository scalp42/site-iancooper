# Print a PDF From C#

Recently, a colleague of mine was wondering how to print a PDF file to a specified print queue from a .NET application.
Some digging around produced [this document](http://partners.adobe.com/public/developer/en/acrobat/sdk/pdf/intro_to_sdk/DeveloperFAQ.pdf)
which includes, on page 27, the command-line option to the Acrobat and Acrobat Reader executables.

    #cs
    /// &lt;summary&gt;
    /// Prints a PDF file to the specified printer using Adobe Reader or Acrobat.
    /// Tested with Adobe Reader XI, but should work with any version | 7 ≤ version ≤ XI.
    /// The registry path might be different on a 64-bit system.
    /// &lt;/summary&gt;
    /// &lt;param name="PdfFile"&gt;path to the PDF file to print&lt;/param&gt;
    /// &lt;param name="PrinterName"&gt;name of the print queue&lt;/param&gt;
    /// &lt;returns&gt;true if no exception&lt;/returns&gt;
    static bool PrintPdf(string PdfFile, string PrinterName) {
    
        // our not successful yet
        bool success = false;
    
        // path to the Reader executable
        string ReaderKey = @"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\AcroRd32.exe";
        string ReaderExe = Microsoft.Win32.Registry.LocalMachine.OpenSubKey(ReaderKey).GetValue("", null).ToString();
        
        // path to the Acrobat executable
        string AcrobatKey = @"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Acrobat.exe";
        string AcrobatExe = Microsoft.Win32.Registry.LocalMachine.OpenSubKey(AcrobatKey).GetValue("", null).ToString();
        
        // prefer to use Reader, fall back to Acrobat
        string Exe = (ReaderExe != null ? ReaderExe : AcrobatExe);
        
        try {
            
            // continue as long as we've found one of the two
            if (Exe != null) {

                // put together our parameters
                string Parameters = string.Format("/s /h /t \"{0}\" \"{1}\"", PdfFile, PrinterName)

                // open up the executable with the right command line
                System.Diagnostics.Process.Start(Exe, Parameters);
        
                // we're successful, as far as we can easily know
                return true;
                
            } else {
            
                // oh noes!!!!1
                throw new Exception("Can't find either AcroRd32 or Acrobat executables.");
            
            }
                
        } catch (Exception e) {
                // log the exception
                Console.Error.WriteLine("Ran into a problem: " + e.Message);
                Console.Error.WriteLine(e.StackTrace);
        }
        
        // return our success value
        return success;
    }

Note that I used the full namespaced identifiers for `Microsoft.Win32.Registry` and `System.Diagnostics.Process`;
these should be `import`ed instead.
