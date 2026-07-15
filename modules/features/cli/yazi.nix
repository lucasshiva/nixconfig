/*
  Yazi (means "duck") is a terminal file manager written in Rust, based on non-blocking async I/O.

  It aims to provide an efficient, user-friendly, and customizable file management experience.

  Reference: https://github.com/sxyazi/yazi
*/
{
  shiv.cli.yazi = {
    homeManager.programs.yazi.enable = true;
  };
}
