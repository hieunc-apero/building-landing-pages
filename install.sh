#!/usr/bin/env bash
#
# Optional convenience installer for building-landing-pages and the skills it composes.
#
# You do not need this. Every command it runs is printed in README.md, and running them
# yourself is the safer habit — each skill below comes from a different third-party
# repository and runs with full agent permissions once installed. Read them first.
#
#   ./install.sh                 the skill + its required dependencies
#   ./install.sh --recommended   the above, plus one skill per remaining stage
#   ./install.sh --all           everything, including the optional motion/GPU set
#   ./install.sh --dry-run       print the commands without running them
#
set -euo pipefail

TIER="required"
DRY=0
for arg in "$@"; do
  case "$arg" in
    --recommended) TIER="recommended" ;;
    --all)         TIER="all" ;;
    --dry-run)     DRY=1 ;;
    -h|--help)     sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 1 ;;
  esac
done

SKILL="hieunc-apero/building-landing-pages@building-landing-pages"
CHECKS="hieunc-apero/building-landing-pages@verifying-landing-pages"

REQUIRED=(
  "hieunc-apero/building-landing-pages@verifying-landing-pages||the 26 pre-launch checks (stage 6)"
  "obra/superpowers|-s brainstorming|structure work before building (stage 2)"
  "anthropics/skills@frontend-design||build a page from blank (stage 5)"
  "anthropics/knowledge-work-plugins@ux-copy||every string on the page (stage 5)"
)
RECOMMENDED=(
  "coreyhaines31/marketingskills@site-architecture||hierarchy, URLs, navigation (stage 2)"
  "nextlevelbuilder/ui-ux-pro-max-skill@ui-ux-pro-max||pick a visual direction (stage 3)"
  "pbakaus/impeccable@impeccable||audit an interface that already exists (stage 5)"
  "ibelick/ui-skills@fixing-accessibility||contrast, ARIA, keyboard, focus (stage 6)"
  "arvindrk/extract-design-system@extract-design-system||competitor tokens (stage 1)"
)
OPTIONAL=(
  "rknall/claude-skills@SVG Logo Designer||the logo itself (stage 3)"
  "lottiefiles/motion-design-skill@motion-design||how motion should behave (stage 5)"
  "greensock/gsap-skills@gsap-core||implementing that motion (stage 5)"
  "pixel-point/animate-text@animate-text||named text effects (stage 5)"
  "iart-ai/webgl-animation-skills@shader-glsl||shader/GPU work (stage 5)"
  "eronred/aso-skills@competitor-analysis||mobile app ASO layer (stage 1)"
)

run() {
  if [ "$DRY" = "1" ]; then
    echo "  $*"
  else
    eval "$@"
  fi
}

install_one() {
  local pkg="${1%%|*}"; local rest="${1#*|}"
  local flags="${rest%%|*}"; local why="${rest#*|}"
  echo "-> $pkg  ($why)"
  run "npx --yes skills add \"$pkg\" $flags -g -y"
}

echo "Installing building-landing-pages (tier: $TIER)"
echo
echo "-> the skill itself"
run "npx --yes skills add \"$SKILL\" -g -y"
echo

echo "Required:"
for e in "${REQUIRED[@]}"; do install_one "$e"; done

if [ "$TIER" != "required" ]; then
  echo
  echo "Recommended:"
  for e in "${RECOMMENDED[@]}"; do install_one "$e"; done
fi

if [ "$TIER" = "all" ]; then
  echo
  echo "Optional:"
  for e in "${OPTIONAL[@]}"; do install_one "$e"; done
fi

echo
if [ "$DRY" = "1" ]; then
  echo "Dry run — nothing was installed."
else
  echo "Done. Verify with:  ls ~/.claude/skills/"
  echo "Anything missing from that list is a stage this skill will quietly do by hand."
fi
