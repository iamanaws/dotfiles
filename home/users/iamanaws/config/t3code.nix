{
  lib,
  hostConfig,
  ...
}:
{
  programs.t3code = lib.optionalAttrs hostConfig.isGraphical {
    enable = true;

    clientSettings = {
      settings = {
        confirmThreadArchive = true;
        confirmThreadDelete = true;
        diffWordWrap = false;
        favorites = [
          {
            provider = "codex";
            model = "gpt-5.5";
          }
          {
            provider = "claudeAgent";
            model = "claude-opus-4-6";
          }
          {
            provider = "claudeAgent";
            model = "claude-sonet-4-6";
          }
        ];
      };
    };
    
    userSettings = {
      enableAssistantStreaming = true;
      providerInstances = {
        cursor = {
          driver = "cursor";
          enabled = true;
          config = {
            enabled = true;
            binaryPath = "agent";
            apiEndpoint = "";
            customModels = [ ];
          };
        };
      };
    };
  };
}