{ config, pkgs, ... }:
{
  # QT Theming
  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
    style.name = "breeze";
  };

  # Environment Variables
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
  };

  # Symlink qt6ct
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
[Appearance]
color_scheme_path=${config.home.homeDirectory}/.config/qt6ct/style-colors.conf
custom_palette=true
standard_dialogs=default
style=Breeze

[Fonts]
fixed="Readex Pro,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular,0,0"
general="Readex Pro,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular,0,0"

[Interface]
activate_item_on_single_click=1
buttonbox_layout=2
cursor_flash_time=1000
dialog_buttons_have_icons=1
double_click_interval=400
gui_effects=@Invalid()
keyboard_scheme=3
menus_have_icons=true
show_shortcuts_in_context_menus=true
stylesheets=@Invalid()
toolbutton_style=4
underline_shortcut=1
wheel_scroll_lines=3
  '';
  
  xdg.configFile."qt6ct/style-colors.conf".text = ''
[ColorScheme]
active_colors=#ffe0def4, #ff2e2b47, #ff403b61, #ff353150, #ff161522, #ff211f33, #ffe0def4, #ffffffff, #ffe0def4, #ff191724, #ff26233a, #ff100f19, #ffebbcba, #ff191724, #ff9ccfd8, #ff030e11, #ff26233a, #ff000000, #ff26233a, #ffe0def4, #ff908caa, #ffebbcba
disabled_colors=#ffbebebe, #ffefefef, #ffffffff, #ffcacaca, #ffbebebe, #ffb8b8b8, #ffbebebe, #ffffffff, #ffbebebe, #ffefefef, #ffefefef, #ffb1b1b1, #ff919191, #ffffffff, #ff44535e, #ff10131c, #fff7f7f7, #ff000000, #ffffffdc, #ff000000, #80000000, #ff919191
inactive_colors=#ffe0def4, #ff2e2b47, #ff403b61, #ff353150, #ff161522, #ff211f33, #ffe0def4, #ffffffff, #ffe0def4, #ff191724, #ff26233a, #ff100f19, #ffebbcba, #ff191724, #ff9ccfd8, #ff030e11, #ff26233a, #ff000000, #ff26233a, #ffe0def4, #ff908caa, #ffebbcba
  '';

  home.packages = with pkgs; [
    bibata-cursors
    kdePackages.breeze
    kdePackages.kcolorscheme
    kdePackages.kconfig
    kdePackages.kiconthemes
    kdePackages.plasma-integration
    papirus-icon-theme
    qt6Packages.qt6ct
  ];
}
