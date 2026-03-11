# Declares top-level options that are used in other modules
{ lib, ... }:
{
  options.username = lib.mkOption {
    type = lib.types.singleLineStr;
    readOnly = true;
    default = "ruairc";
  };

  options.hostname = lib.mkOption {
    type = lib.types.singleLineStr;
    readOnly = true;
    default = "";
  };
}
