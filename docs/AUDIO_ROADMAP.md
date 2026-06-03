# Audio Roadmap

Audio should make Teret Bet more useful for children who understand Amharic but
cannot read independently yet. Audio should arrive gradually so the MVP remains
stable.

## Stage 1: Story-Level Audio

Add one narration file for the full story.

Useful for:

* Bedtime listening
* Parent-child reading support
* Offline story replay

Planned fields:

```json
{
  "storyAudioUrl": null,
  "durationSeconds": null,
  "narratorName": null
}
```

## Stage 2: Page-Level Audio

Add one audio file per page so children can listen page by page.

Planned page field:

```json
{
  "pageAudioUrl": null
}
```

The reader can later show play/pause controls without forcing a full audio
player into the first MVP.

## Stage 3: Word Timing And Highlighting

Add optional word timing metadata for read-along highlighting.

Planned field:

```json
{
  "wordTimingJsonUrl": null
}
```

This should remain optional because timing files take extra production effort.

## Stage 4: Offline Audio Downloads

After story audio works, add offline downloads for selected stories.

Considerations:

* Storage size per story
* Download progress
* Parent-controlled downloads
* Deleting downloaded audio
* Hive metadata for local file paths

## Audio Metadata Summary

Story-level fields:

* `storyAudioUrl`
* `durationSeconds`
* `narratorName`

Page-level fields:

* `pageAudioUrl`
* `wordTimingJsonUrl`

All audio fields should be nullable until audio production is ready.
