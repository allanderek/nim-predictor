import prologue
import karax/[karaxdsl, vdom]


# This is <head> html section. It's shared across all templates
proc sharedHead*(ctx: Context, staticPath : string, title: string, includeElmScript: bool): VNode =
  let vNode = buildHtml(head):
    title: text title 
    link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/gh/kimeiga/bahunya/dist/bahunya.min.css")
    link(rel = "stylesheet", href = staticPath & "/styles.css")
    if includeElmScript:
      link(rel = "preload", href = staticPath & "/main.js")
      script(src = staticPath & "/main.js")
  return vNode
