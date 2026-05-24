import type { ExtensionAPI, ExtensionCommandContext } from "@earendil-works/pi-coding-agent";

/**
 * Utility commands for the wiki repo.
 *
 * - /vscode — open current repo in VS Code
 * - /code   — alias for /vscode
 */
export default function (pi: ExtensionAPI) {
  const handler = async (_args: string, ctx: ExtensionCommandContext) => {
    const { execSync } = await import("node:child_process");
    try {
      execSync("code .", { cwd: ctx.cwd, stdio: "inherit" });
    } catch {
      ctx.ui.notify("VS Code CLI not available. Install `code` in PATH.", "error");
    }
  };

  pi.registerCommand("vscode", {
    description: "Open current repo in VS Code",
    handler,
  });

  pi.registerCommand("code", {
    description: "Open current repo in VS Code (alias for /vscode)",
    handler,
  });
}
