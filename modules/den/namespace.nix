{ inputs, ... }: {
  # `True` means we're exporting this namespace so that other modules can use it.
  imports = [ (inputs.den.namespace "shiv" true) ];
}
