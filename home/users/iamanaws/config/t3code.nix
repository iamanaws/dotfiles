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
            provider = "claudeAgent";
            model = "claude-opus-4-8";
          }
          # {
          #   provider = "codex";
          #   model = "gpt-5.5";
          # }
          {
            provider = "cursor";
            model = "composer-2.5";
          }
          {
            provider = "cursor";
            model = "gpt-5.5";
          }
          {
            provider = "cursor";
            model = "gpt-5.4";
          }
        ];
        providerModelPreferences = {
          codex.hiddenModels = [
            "gpt-5.2"
            "gpt-5.3-codex"
          ];
          claudeAgent.hiddenModels = [
            "claude-opus-4-6"
            "claude-opus-4-5"
            "claude-opus-4-7"
            "claude-sonnet-4-6"
            "claude-haiku-4-5"
          ];
          cursor.hiddenModels = [
            "claude-sonnet-4-6"
            "gpt-5.3-codex"
            "claude-opus-4-7"
            "grok-build-0.1"
            "claude-opus-4-6"
            "claude-opus-4-5"
            "gpt-5.2"
            "gemini-3.1-pro"
            "gpt-5.4-mini"
            "gpt-5.4-nano"
            "claude-haiku-4-5"
            "grok-4.3"
            "claude-sonnet-4-5"
            "gpt-5.2-codex"
            "gpt-5.1-codex-max"
            "gpt-5.1"
            "gemini-3-flash"
            "gemini-3.5-flash"
            "gpt-5.1-codex-mini"
            "claude-sonnet-4"
            "gpt-5-mini"
            "gemini-2.5-flash"
            "kimi-k2.5"
            "claude-fable-5"
          ];
        };
      };
    };

    userSettings = {
      enableAssistantStreaming = true;
      providerInstances = {
        cursor = {
          driver = "cursor";
          enabled = true;
          config.binaryPath = "cursor-agent";
        };
        grok = {
          driver = "grok";
          enabled = false;
        };
        opencode = {
          driver = "opencode";
          enabled = false;
        };
      };
    };
  };
}
