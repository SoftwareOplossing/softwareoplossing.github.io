{
  lib,
  stdenvNoCC,
  jekyll,
}:
let
  fs = lib.fileset;
  srcLoc = ./../..;
  srcFiles = fs.difference (fs.gitTracked srcLoc) (
    fs.unions [
      (fs.fileFilter (file: file.hasExt "nix") srcLoc)
      (srcLoc + "/flake.lock")
      (srcLoc + "/runLocal.bat")
      (srcLoc + "/README.md")
      (srcLoc + "/LICENSE")
      (srcLoc + "/CNAME")
    ]
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "www";
  version = "0.0.1";

  src = fs.toSource {
    root = srcLoc;
    fileset = srcFiles;
  };

  nativeBuildInputs = [
    jekyll
  ];

  postInstall = ''
    mkdir -p $out
    jekyll build --destination $out
  '';
})
