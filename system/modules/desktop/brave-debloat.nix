{
  environment.etc."brave/policies/managed/debloat.json".text = builtins.toJSON {
    BraveRewardsDisabled = true;
    BraveWalletDisabled = true;
    BraveVPNDisabled = true;
    BraveAIChatEnabled = false;
    BraveNewsDisabled = true;
    BraveTalkDisabled = true;
    SyncDisabled = true;
    TorDisabled = true;
    DnsOverHttpsMode = "automatic";
  };
}