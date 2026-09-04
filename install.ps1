<#
    Optional convenience installer for building-landing-pages and the skills it composes.

    You do not need this. Every command it runs is printed in README.md, and running them
    yourself is the safer habit -- each skill below comes from a different third-party
    repository and runs with full agent permissions once installed. Read them first.

      .\install.ps1                 the skill + its required dependencies
      .\install.ps1 -Recommended    the above, plus one skill per remaining stage
      .\install.ps1 -All            everything, including the optional motion/GPU set
      .\install.ps1 -DryRun         print the commands without running them
#>
param(
    [switch]$Recommended,
    [switch]$All,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$skill = 'hieunc-apero/building-landing-pages@building-landing-pages'

$reqSkills = @(
    @{ pkg = 'obra/superpowers'; flags = @('-s', 'brainstorming'); why = 'structure work before building (stage 2)' },
    @{ pkg = 'anthropics/skills@frontend-design'; flags = @(); why = 'build a page from blank (stage 5)' },
    @{ pkg = 'anthropics/knowledge-work-plugins@ux-copy'; flags = @(); why = 'every string on the page (stage 5)' }
)
$recSkills = @(
    @{ pkg = 'nextlevelbuilder/ui-ux-pro-max-skill@ui-ux-pro-max'; flags = @(); why = 'pick a visual direction (stage 3)' },
    @{ pkg = 'pbakaus/impeccable@impeccable'; flags = @(); why = 'audit an interface that already exists (stage 5)' },
    @{ pkg = 'ibelick/ui-skills@fixing-accessibility'; flags = @(); why = 'contrast, ARIA, keyboard, focus (stage 6)' },
    @{ pkg = 'arvindrk/extract-design-system@extract-design-system'; flags = @(); why = 'competitor tokens (stage 1)' }
)
$optSkills = @(
    @{ pkg = 'rknall/claude-skills@SVG Logo Designer'; flags = @(); why = 'the logo itself (stage 3)' },
    @{ pkg = 'lottiefiles/motion-design-skill@motion-design'; flags = @(); why = 'how motion should behave (stage 5)' },
    @{ pkg = 'greensock/gsap-skills@gsap-core'; flags = @(); why = 'implementing that motion (stage 5)' },
    @{ pkg = 'pixel-point/animate-text@animate-text'; flags = @(); why = 'named text effects (stage 5)' },
    @{ pkg = 'iart-ai/webgl-animation-skills@shader-glsl'; flags = @(); why = 'shader/GPU work (stage 5)' },
    @{ pkg = 'eronred/aso-skills@competitor-analysis'; flags = @(); why = 'mobile app ASO layer (stage 1)' }
)

function Install-Skill($pkg, $flags, $why) {
    if ($why) { Write-Host "-> $pkg  ($why)" -ForegroundColor Cyan }
    else       { Write-Host "-> $pkg" -ForegroundColor Cyan }
    $argv = @('--yes', 'skills', 'add', $pkg) + $flags + @('-g', '-y')
    if ($DryRun) {
        Write-Host "   npx $($argv -join ' ')" -ForegroundColor DarkGray
    } else {
        & npx @argv | Out-Null
        if ($LASTEXITCODE -ne 0) { Write-Host "   [!] failed to install $pkg" -ForegroundColor Yellow }
    }
}

$tier = if ($All) { 'all' } elseif ($Recommended) { 'recommended' } else { 'required' }
Write-Host "Installing building-landing-pages (tier: $tier)`n" -ForegroundColor White

Install-Skill $skill @() 'the skill itself'
Write-Host "`nRequired:" -ForegroundColor White
foreach ($e in $reqSkills) { Install-Skill $e.pkg $e.flags $e.why }

if ($tier -ne 'required') {
    Write-Host "`nRecommended:" -ForegroundColor White
    foreach ($e in $recSkills) { Install-Skill $e.pkg $e.flags $e.why }
}

if ($tier -eq 'all') {
    Write-Host "`nOptional:" -ForegroundColor White
    foreach ($e in $optSkills) { Install-Skill $e.pkg $e.flags $e.why }
}

Write-Host ""
if ($DryRun) {
    Write-Host "Dry run -- nothing was installed." -ForegroundColor Cyan
} else {
    Write-Host "Done. Verify with:  ls ~/.claude/skills/" -ForegroundColor Cyan
    Write-Host "Anything missing from that list is a stage this skill will quietly do by hand." -ForegroundColor DarkGray
}
