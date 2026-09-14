# Review preferences — what "done" looks like to this reviewer

Distilled from one long review cycle on a production web app: ~15 rounds of
corrections on a build that started from the phone layout. Every item below
cites something the reviewer actually sent back, so treat this as evidence,
not taste.

This is a **contract for the output**, not a style opinion. Run it before
showing work, not after it comes back.

---

## 1. Desktop is its own layout, never the phone layout at a bigger size

Raised four separate times, in four different words: *"đang bị giống responsive
iPad quá"*, *"chưa optimal cho desktop"* (×2), *"chưa đủ đẹp"*. It is the single
most likely reason work gets bounced.

**What triggers it, concretely:**

| Tell | Why it reads wrong |
|---|---|
| Icon rail down the left | App chrome. A website has a top nav. |
| Swipe carousel with dots | Touch pattern. Desktop scans a grid. |
| Phone measure (440–560px) kept at 1400px | The page becomes a strip in a void |
| A screen with no way back into the product | Landing on a page with no nav is the one thing a website never does |
| Content block against one edge of a wide container | See §2 |

**Check before showing:** open every route at 1400px. If a route looks like the
phone screenshot with margins, it is not done.

## 2. A narrow block inside a wide container centres itself

*"đang bị lệch sang 1 bên này"* — sent with a screenshot, about a 720px column
inside a 1440px shell.

The container being centred is **not** enough. Any block with a max-width
smaller than its parent needs its own `mx-auto`, or it hugs the parent's left
edge and the whole page reads as shoved aside.

**Check:** `Math.abs((box.left + box.right) / 2 - clientWidth / 2) <= 2`.

## 3. The surface may have life; individual elements stay quiet

Two requests that look contradictory and are not:

- *"tôi muốn có thêm chút chút gradient điểm xuyết"* → then *"tím có thể mạnh
  hơn chút, cân nhắc tím - hồng ở một số chỗ (đừng tacky quá)"*
- *"sao card Premium lại nổi hơn z, k cần đâu / hoặc nổi subtle hơn"*

They want the **page** to feel lit. They will cut any **element** that shouts.

**The test that survived review:** an accent has to be the *only* signal for its
message. The Premium card's tint was cut because the header already carried a
PRO button and the row was already first on the page — position and copy had
said it twice before the colour said it a third time.

Safe places for accent, in practice: ambient page wash, active-state indicator,
hover feedback, section seam, the one committing CTA. Not: a card that is
already first in reading order.

## 4. Fix one screen, then sweep its siblings

*"check ở gallery blabla nx"* — said immediately after a fix landed on Settings.

Changing a type size, ratio, spacing or token on one screen is a prompt to grep
the same property everywhere else. This single habit caught, in one pass:

- page titles at two different sizes depending on the screen
- one font utility written two different ways across six files
- three artwork ratios coexisting

**Check:** after any token- or scale-level change, `grep` the property across
`app/` and `components/` before calling it done.

## 5. A reference image is structural, not a moodboard

*"không giống cái tôi gửi, vòng tròn ôm cả icon + text, subdued primary"* —
after a tab bar was rebuilt from a screenshot they sent.

When they send an image, replicate **what encloses what** and **how the fill is
treated**. Do not extract a vibe from it. The correction above was purely
structural: the indicator wrapped the icon *and* the label, and the fill was a
muted flat primary, not a gradient.

**Check:** before building, say out loud what contains what in the reference. If
that sentence doesn't match your markup, the markup is wrong.

## 6. They report with a screenshot; answer with measurements

A multiple-choice diagnostic question was dismissed outright. A screenshot
arrived instead.

They will not narrate symptoms in prose, and they do not want to be
interviewed. Take the screenshot, go read the real numbers out of the running
page — element boxes, computed styles, contrast ratios, overflow — and report
the diagnosis with those numbers in it.

Every accepted fix in that session was argued from a measurement. Every
speculation was wrong at least once, including "the browser is too old" and
"the sticky header is fine".

## 7. Small scale is in scope

*"chữ Prompt suggestions hơi nhỏ à"*. A 7px off-centre was worth a message.

Typography one step off the system, a few pixels of misalignment, and one
element heavier than its neighbours all get reported. Budget a pass for them
rather than treating them as nits after handoff.

## 8. The whole surface is the target, not the button inside it

*"tôi muốn nhấn vào banner cx ra style, hiện tại nhấn vào CTA mới chuyển màn"*.

If a card, banner or tile depicts a destination, the whole tile goes there. A
CTA inside it becomes a label, not a second control — one interactive element,
no nested button inside a link.

## 9. Live data beats the repo's own fixtures

*"cân nhắc thay về ratio 9:16 vì ảnh gốc đang như z"* — they were right, and the
repo's committed fixtures said otherwise.

When a claim about content can be measured, measure it against the live source
before trusting checked-in sample data. In that case the fixtures predated the
current artwork and inverted the answer.

## 10. Mobile is sacred, and they will catch the regression

*"mobile: style đang chắn hết màn, k nhìn đc chỗ để upload"* — a mobile break
caused by a desktop-motivated change, reported within one round.

Every desktop change gets re-checked at 390px before it ships. Assume the
regression will be found within one round if it isn't.

---

## Before showing work

1. Every route at **390 / 820 / 1400**.
2. Narrow blocks centred (§2).
3. Siblings swept for the property just changed (§4).
4. Contrast measured, not eyeballed, in **both** themes if the product has two.
5. Zero horizontal overflow at every width.
6. Say what you deliberately did **not** do, and why. Ending with a real open
   question was consistently accepted; presenting finished work as settled when
   a judgement call was buried in it was not.
