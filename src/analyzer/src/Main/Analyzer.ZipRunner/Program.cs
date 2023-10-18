using System;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Reflection;

string mainFileToRun = "%mainFileToRun%";

string zipPath = Path.Combine(Path.GetTempPath(), "application.zip");

try
{
    using (var resourceStream = Assembly.GetExecutingAssembly().GetManifestResourceStream("application.zip"))
    {
        if (resourceStream is null)
        {
            Console.Error.WriteLine("This zip runner is a stub and does not have an application.zip embedded.");
            return 1;
        }

        Console.WriteLine($"Copying application.zip to {zipPath}.");
        using (var fileStream = File.Create(zipPath))
            resourceStream.CopyTo(fileStream);
    }

    string extractionPath = Path.Combine(
        Environment.GetFolderPath(Environment.SpecialFolder.Desktop),
        Path.GetFileNameWithoutExtension(mainFileToRun));

    Console.WriteLine($"Extracting zip archive to {extractionPath}.");    
    ZipFile.ExtractToDirectory(zipPath, extractionPath);

    string mainExecutablePath = Path.Combine(extractionPath, mainFileToRun);
    Console.WriteLine($"Running {mainExecutablePath}");
    Process.Start(mainExecutablePath);
    return 0;
}
finally
{
    if (File.Exists(zipPath))
    {
        Console.WriteLine($"Deleting {zipPath}.");
        File.Delete(zipPath);
    }
}
    
