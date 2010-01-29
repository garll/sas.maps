function CBuildSource(Folder, Ext){
  this.Ext = Ext;
  this.fso = WScript.CreateObject("Scripting.FileSystemObject");
  this.Folder = this.fso.GetFolder(Folder);

  this.SourceCheckExtRegExp = new RegExp("^" + this.Ext + "$", "i");

  this.CheckExt = function(Folder){
    return this.fso.GetExtensionName(Folder.Name).match(this.SourceCheckExtRegExp);
  };

  this.GetSourceFoldersEnumerator = function(){
    return new Enumerator(this.Folder.SubFolders);
  };
};

function CBuilder(FolderName){
  this.fso = WScript.CreateObject("Scripting.FileSystemObject");
  this.WshShell = WScript.CreateObject("WScript.Shell");
  this.FolderExists = false;
  
  this.FolderName = FolderName;
  if (FolderName.length == 0){
    this.FolderName = ".";
  };

  this.GetNewFullFileName = function(FileName){
    if (!this.FolderExists){
      if (!this.fso.FolderExists(this.FolderName)){
        this.Folder = this.fso.CreateFolder(FolderName);
        this.FolderExists = true;
      }else{
        this.Folder = this.fso.GetFolder(this.FolderName);
        this.FolderExists = true;
      };
    };
    return this.fso.BuildPath(this.Folder.Path, this.fso.GetFileName(FileName));
  };
  this.GetCommandLine = function(SourceFolder, FileName){
    return "7za  a -tzip \""+ FileName + "\" \"" + SourceFolder + "\\*.*\"" ;
  };
  this.ProcessFolder = function(Folder){
    var NewFileName = this.GetNewFullFileName(Folder.Name);
    var FolderFullName = Folder.Path;
    if (this.fso.FileExists(NewFileName)){
      this.fso.DeleteFile(NewFileName);
    };
    var CommandLine = this.GetCommandLine(FolderFullName, NewFileName);
    WScript.Echo(CommandLine);
    var Pipe = this.WshShell.Exec(CommandLine);
    while(!Pipe.StdOut.AtEndOfStream){
      WScript.StdOut.WriteLine(Pipe.StdOut.ReadLine());
    };
  }
};

  var Source = new CBuildSource(".", "zmp");
  var Builder = new CBuilder(".\\.bin");
  var oFiles = Source.GetSourceFoldersEnumerator();
  for (; !oFiles.atEnd(); oFiles.moveNext()){
    var oFile = oFiles.item();
    if (Source.CheckExt(oFile)){
      Builder.ProcessFolder(oFile);
    };
  };
