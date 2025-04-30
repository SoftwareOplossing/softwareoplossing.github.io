{
  writeShellApplication,
  myWebsite,
  caddy,
}:

writeShellApplication {
  name = "www-serve";

  runtimeInputs = [
    caddy
  ];

  text = ''
    caddy file-server \
      --root ${myWebsite} \
      --listen ":8080"
  '';
}
