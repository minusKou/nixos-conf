{ ... }:

{
  services.pipewire.extraConfig.pipewire."99-virtual-sinks" = {
    "context.objects" = [
      {
        factory = "adapter";
        args = {
          "factory.name"     = "support.null-audio-sink";
          "node.name"        = "virtual_capture_card";
          "node.description" = "Virtual Cable: Capture Card";
          "media.class"      = "Audio/Sink";
          "audio.position"   = [ "FL" "FR" ];
        };
      }
      {
        factory = "adapter";
        args = {
          "factory.name"     = "support.null-audio-sink";
          "node.name"        = "virtual_presentation";
          "node.description" = "Virtual Cable: Presentation";
          "media.class"      = "Audio/Sink";
          "audio.position"   = [ "FL" "FR" ];
        };
      }
      {
        factory = "adapter";
        args = {
          "factory.name"     = "support.null-audio-sink";
          "node.name"        = "virtual_extra";
          "node.description" = "Virtual Cable: Extra";
          "media.class"      = "Audio/Sink";
          "audio.position"   = [ "FL" "FR" ];
        };
      }
    ];
  };
}
