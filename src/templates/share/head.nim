import prologue
import karax/[karaxdsl, vdom]


# This is <head> html section. It's shared across all templates
proc sharedHead*(ctx: Context, title: string): VNode =
  let
    env = loadPrologueEnv(".env")
    appName = env.getOrDefault("appName", "Prologue")

  let vNode = buildHtml(head):
    title: text title & " - " & appName
    # link(rel = "stylesheet", href = "/static/mvp.css")
    link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/gh/kimeiga/bahunya/dist/bahunya.min.css")
  return vNode
