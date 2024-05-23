import prologue
import karax/[karaxdsl, vdom]


proc sharedNav*(ctx: Context): VNode =
  let fullname = ctx.session.getOrDefault("userFullname", "")
  let vNode = buildHtml(header):
    nav:
      ul:
        li:
          a(href = "/formulae"):
            text "Formula E predictions"
        li:
          a(href = "/leaderboard/2023-24"):
            text "Leaderboard"
          ul:
            li:
              a(href = "/leaderboard/2023-24"):
                text "Current"
            li:
              a(href = "/leaderboard/2022-23"):
                text "2022-23"
        if fullname.len == 0:
          li: a(href = "/auth/register"): text "Register"
          li: a(href = "/auth/login"): text "Log In"
        else:
          li: a(href = "/profile"): text fullname
          li: a(href = "/auth/logout"): text "Log Out"

  return vNode
