{
  programs.nixvim = {
    autoCmd = [
      # program templates
      {
        event = [ "BufNewFile" ];
        pattern = [ "*.c" ];
        command = "0r ~/development/templates/template.c";
      }
      {
        event = [ "BufNewFile" ];
        pattern = [ "*.cpp" ];
        command = "0r ~/development/templates/template.cpp";
      }
      {
        event = [ "BufNewFile" ];
        pattern = [ "*.py" ];
        command = "0r ~/development/templates/template.py";
      }
      {
        event = [ "BufNewFile" ];
        pattern = [ "*.s" ];
        command = "0r ~/development/templates/template.s";
      }
      {
        event = [ "BufNewFile" ];
        pattern = [ "*.asm" ];
        command = "0r ~/development/templates/template.asm";
      }
      {
        event = [ "BufNewFile" ];
        pattern = [ "*.h" ];
        command = "0r ~/development/templates/template.h";
      }
      {
        event = "VimEnter";
        pattern = "*";
        command = ''
          highlight NotifyERRORBorder guibg=#161616 guifg=#161616
          highlight NotifyWARNBorder guibg=#161616 guifg=#161616
          highlight NotifyINFOBorder guibg=#161616 guifg=#161616
          highlight NotifyDEBUGBorder guibg=#161616 guifg=#161616
          highlight NotifyTRACEBorder guibg=#161616 guifg=#161616
          highlight HarpoonWindow guibg=#161616 guifg=#ffffff
          highlight HarpoonBorder guibg=#161616 guifg=#ffffff
          highlight HarpoonMenu guibg=#161616 guifg=#ffffff
          highlight Normal guibg=NONE guifg=#ffffff
          highlight NormalFloat guibg=#161616 guifg=#ffffff
          highlight FloatBorder guibg=#161616 guifg=#ffffff
          highlight TelescopeNormal guibg=#161616
          highlight TelescopeBorder guibg=#161616 guifg=#ffffff
          highlight TelescopePromptNormal guibg=#161616
          highlight TelescopePromptBorder guibg=#161616 guifg=#ffffff
          highlight TelescopePreviewNormal guibg=#161616
          highlight TelescopePreviewBorder guibg=#161616 guifg=#ffffff
          highlight TelescopeResultsNormal guibg=#161616
          highlight TelescopeResultsBorder guibg=#161616 guifg=#ffffff
          highlight NotifyBackground guibg=#161616 guifg=#161616
          highlight NotifyERRORBody guibg=#161616 guifg=#BF616A
          highlight NotifyWARNBody guibg=#161616 guifg=#EBCB8B
          highlight NotifyINFOBody guibg=#161616 guifg=#88C0D0
          highlight NotifyDEBUGBody guibg=#161616 guifg=#81A1C1
          highlight NotifyTRACEBody guibg=#161616 guifg=#B48EAD
          highlight FloatTermNormal guibg=#161616 guifg=#ffffff
          highlight FloatTermBorder guibg=#161616 guifg=#ffffff
          highlight Floaterm guibg=#161616
        '';
      }
    ];
  };
}
