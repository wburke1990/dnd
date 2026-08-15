# Iliad 13.650–655 — the death of Harpalion, across translations

*Real-world reference (not in-world canon). A translation comparison for the line we
want for blood consecration: Harpalion dies, and his blood wets the ground. Companion
to [the Iliad, blood on the ground](../handouts/iliad-blood-on-the-ground.md) and
[the rite at the Jotunheim trees](../encounters/jotunheim-trees-rite.md).*

**Why this one.** Of the blood-and-earth lines in the poem, this is the one where a
single named man's blood goes into the ground and the poem stops to say so. The others
are battlefield-wide (4.451, 17.360) or belong to a chariot (20.499). Here it is one
death, one body, and the ground taking it.

**The Greek**, 13.654–655. `[check]` — transcribed from memory; the network here blocks
Perseus, so verify before quoting the Greek anywhere.

> κεῖτο ταθείς, ἐκ δ' αἷμα μέλαν ῥέε, δεῦε δὲ γαῖαν.

`δεῦε δὲ γαῖαν` — "and it wetted the earth." `δεύω` is the ordinary verb for wetting or
soaking a thing, the same word used of tears wetting a cheek. Homer does not reach for
a special word here.

---

## The comparison

| Translator (year) | The line | Note |
|---|---|---|
| George Chapman (1611) | `[to fill]` | |
| Alexander Pope (1715–20) | *"Sunk in his sad companions' arms he lay, / And in short pantings sobb'd his soul away; / (Like some vile worm extended on the ground;) / While life's red torrent gush'd from out the wound."* | Verified. The ground gets nothing — Pope keeps the blood on the wound and drops the earth entirely. |
| William Cowper (1791) | `[to fill]` | |
| Lang, Leaf & Myers (1883) | `[to fill]` | The literal Victorian prose; likely the closest to the Greek word order. |
| Samuel Butler (1898) | `[to fill]` | |
| A. T. Murray (1924) | *"and lay stretched out like a worm on the earth; and the black blood flowed forth and wetted the ground."* | Verified. Keeps `δεῦε` as "wetted." |
| E. V. Rieu (1950) | `[to fill]` | |
| Richmond Lattimore (1951) | `[to fill]` | |
| Robert Fitzgerald (1974) | `[to fill]` | |
| Robert Fagles (1990) | `[to fill]` | |
| Stanley Lombardo (1997) | `[to fill]` | |
| A. S. Kline (2009) | *"He collapsed on the spot, and sinking into the arms of his friends, breathed out his life and lay in the dust like a worm, the dark blood flowing and soaking the ground."* | Verified. "Soaking" for `δεῦε`. |
| Anthony Verity (2011) | `[to fill]` | |
| Stephen Mitchell (2011) | `[to fill]` | |
| Caroline Alexander (2015) | `[to fill]` | |
| Peter Green (2015) | `[to fill]` | |
| Emily Wilson (2023) | `[to fill]` | |

**Unattributed, found in circulation** — turned up in search without a translator
attached, so do not credit it until someone checks a printed copy:

> *"he breathed out his life, like an earthworm along the ground lying down; his dark
> blood flowed out and soaked the earth."*

---

## The words that carry it

Three choices separate the versions, and they are what to compare on:

- **`δεῦε`** — wetted, soaked, drenched, watered. Murray's "wetted" is flat and
  physical; Kline's "soaking" is wetter; Pope cuts the earth out of the sentence.
- **the worm** — *"stretched out like a worm"* is in the Greek and most translators
  keep it. Pope apologizes for it with "some vile worm."
- **`αἷμα μέλαν`** — black blood, or dark blood. The Greek says black.

---

## Prompt to finish this locally

The container this was started in blocks Perseus, Theoi, Wikisource, Gutenberg and
archive.org, so the empty rows could not be filled here. Run this in a local session
with network:

```
Fill in the empty rows of references/iliad-harpalion-translations.md — the death of
Harpalion, Iliad 13.650-655, in each listed translation.

For each translator, get the sentence covering Greek lines 654-655 (the body stretched
out like a worm, the black blood running, the ground being wetted). Include enough of
the preceding sentence to make it read. Quote verbatim; do not paraphrase, normalize
spelling, or tidy punctuation. If you cannot find a translation's exact wording, leave
the row as [to fill] and say so — never reconstruct one from memory or from another
translation.

Public-domain texts (Chapman, Pope, Cowper, Lang-Leaf-Myers, Butler, Murray) are on
Perseus, Theoi, Wikisource and Gutenberg. For in-copyright ones (Lattimore, Fitzgerald,
Fagles, Lombardo, Verity, Mitchell, Alexander, Green, Wilson) a single line quoted for
comparison is fine; Google Books and the Internet Archive lending previews will have
them.

Also verify the two lines of Greek at the top and drop the [check] flag if they are
right, and settle the unattributed rendering at the bottom - either credit it or cut
it.

Then fill the note column with what each version does with three things: the verb for
wetting the ground, whether the worm survives, and whether the blood is black or dark.

Repo rules: search with rg, never find -exec, and no shell loops or && chains. Run
`uv --directory scripts run prose-lint` before committing. Commit to main with the
message in a temp file via git commit -F, authored as William with the Claude
co-author trailer, then push.
```
