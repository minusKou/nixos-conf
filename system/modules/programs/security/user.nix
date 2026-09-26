{ username, ... }:
{
  # User account
  users.users.${username} = {
    isNormalUser = true;
    description = "alhanz";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
  };
}