import '../models/practice_models.dart';

class PracticeLibrary {
  static const moods = ['steady', 'lighter', 'tired', 'unchanged'];
  static const prompts = [
    'What caught your attention today?',
    'Where did you use less effort?',
    'What is complete for now?',
    'Which small rhythm would you repeat?'
  ];
  static const patterns = <BreathPattern>[
    BreathPattern(
        id: 'four-columns',
        name: 'Four columns',
        teaching:
            'Follow four even phases: inhale, pause, exhale, pause. The rising columns are a guide, not a target. Keep the breath comfortable. Stop or choose a no-hold rhythm if pauses feel uneasy.',
        rounds: 4,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 4),
          BreathPhase(label: 'Pause full', seconds: 4),
          BreathPhase(label: 'Exhale', seconds: 4),
          BreathPhase(label: 'Pause empty', seconds: 4)
        ]),
    BreathPattern(
        id: 'easy-current',
        name: 'Easy current',
        teaching:
            'Three counts in and four out, with no holds. Use a small, comfortable breath. Leave the count behind whenever you prefer.',
        rounds: 6,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 3),
          BreathPhase(label: 'Exhale', seconds: 4)
        ]),
    BreathPattern(
        id: 'level-tide',
        name: 'Level tide',
        teaching:
            'Let four counts in meet four counts out. There are no pauses to hold. Return to ordinary breathing if counting feels like effort.',
        rounds: 5,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 4),
          BreathPhase(label: 'Exhale', seconds: 4)
        ]),
  ];
  static const poses = <PoseCard>[
    PoseCard(
        id: "sound-distance",
        name: "Sound distance",
        aka: "ATTENTION / LISTENING",
        setup:
            "Listen for a nearby sound, then a farther one. Keep the head comfortable and let sounds arrive without searching.",
        breath: "Breathe normally in the background.",
        ifThis:
            "If listening feels tiring, notice the contact of a foot instead."),
    PoseCard(
        id: "heel-lift",
        name: "Seated heel lift",
        aka: "MOVEMENT / FEET",
        setup:
            "On a sturdy chair, keep the front of a foot on the floor and lift the heel slightly. Lower softly and rest.",
        breath: "Let breathing continue without matching it to the movement.",
        ifThis:
            "Leave the foot still and notice its pressure if the movement is uncomfortable."),
    PoseCard(
        id: "finger-fan",
        name: "Finger fan",
        aka: "MOVEMENT / HANDS",
        setup:
            "Support your forearm. Open the fingers a little, then return to their relaxed curve without squeezing.",
        breath: "Use your natural rhythm; no breath holds.",
        ifThis:
            "Use a smaller motion or rest the hand if any joint feels strained."),
    PoseCard(
        id: "forward-reach",
        name: "Low forward reach",
        aka: "MOVEMENT / ARMS",
        setup:
            "Sit with support and move one hand forward below shoulder height. Keep the elbow soft and return to your thigh.",
        breath: "Keep breathing comfortably while you move.",
        ifThis:
            "Imagine the movement with the hand resting if reaching is uncomfortable."),
    PoseCard(
        id: "day-closure",
        name: "Day closure",
        aka: "REST / REFLECTION",
        setup:
            "Recall one ordinary action you completed today. Name it briefly, then return to the support beneath you.",
        breath: "There is no breathing task to complete.",
        ifThis:
            "Skip the memory and listen to a quiet sound if reviewing the day feels unhelpful."),
  ];
  static const sessions = <PracticeSession>[
    PracticeSession(
        id: "sound-compass",
        title: "Sound compass",
        subtitle: "Listen nearby, then let the sound field widen.",
        kind: "sit",
        minutes: 8,
        level: "smooth",
        teaching:
            'Use a comfortable supported position. Follow each cue without forcing a sensation. Pause or stop whenever you need.',
        aims: [
          "ease",
          "sit"
        ],
        steps: [
          PracticeStep(
              title: "Find a base",
              cue:
                  "Sit with your back comfortably supported. Keep your eyes open or closed. Notice one steady point of contact with the chair before listening.",
              seconds: 120),
          PracticeStep(
              title: "Listen nearby",
              cue:
                  "Notice a sound close to you. There is no need to identify its source. Listen for its beginning, texture and ending. If the room is quiet, notice the quiet.",
              seconds: 120),
          PracticeStep(
              title: "Widen the field",
              cue:
                  "Allow a farther sound to enter attention. Move between near and far without turning your head or searching for a special sound.",
              seconds: 120),
          PracticeStep(
              title: "Return without effort",
              cue:
                  "Let all sounds share the background. Feel the chair again. Choose one ordinary sound as a reminder that you can pause during the day.",
              seconds: 120),
        ]),
    PracticeSession(
        id: "near-and-far",
        title: "Near and far",
        subtitle: "A gentle attention lesson using the space around you.",
        kind: "sit",
        minutes: 8,
        level: "smooth",
        teaching:
            'Use a comfortable supported position. Follow each cue without forcing a sensation. Pause or stop whenever you need.',
        aims: [
          "ease",
          "sit"
        ],
        steps: [
          PracticeStep(
              title: "Choose two places",
              cue:
                  "Sit in a comfortable position. Choose one object nearby and another farther away. Neither needs to be interesting. Avoid bright light.",
              seconds: 120),
          PracticeStep(
              title: "Notice the near",
              cue:
                  "Rest your gaze on the nearby object. Notice one colour and one shape. Blink normally. If looking is tiring, use the feel of a nearby surface instead.",
              seconds: 120),
          PracticeStep(
              title: "Allow the far",
              cue:
                  "Let your gaze move to the farther object without straining. Notice the space between you and it. Alternate slowly only if that feels comfortable.",
              seconds: 120),
          PracticeStep(
              title: "See the whole room",
              cue:
                  "Let your eyes take in a wider view. You do not need to study anything. Feel your feet and finish with an ordinary, uncounted breath.",
              seconds: 120),
        ]),
    PracticeSession(
        id: "heel-and-toe",
        title: "Heel and toe",
        subtitle: "Explore a small, seated change of foot pressure.",
        kind: "mobility",
        minutes: 8,
        level: "smooth",
        teaching:
            'Use a comfortable supported position. Follow each cue without forcing a sensation. Pause or stop whenever you need.',
        aims: [
          "stretch",
          "ease"
        ],
        steps: [
          PracticeStep(
              title: "Set up your seat",
              cue:
                  "Use a sturdy chair with both feet comfortably on the floor. Keep the chair still. If your feet do not reach, use a stable support.",
              seconds: 120),
          PracticeStep(
              title: "A light heel lift",
              cue:
                  "Keep the front of one foot down and lift the heel a little. Lower it softly. Repeat a few times, then rest. Stay within a painless range.",
              seconds: 120),
          PracticeStep(
              title: "A light toe lift",
              cue:
                  "Keep the heel down and gently lift the front of the same foot. Lower it and rest. Change feet, keeping each motion small and unhurried.",
              seconds: 120),
          PracticeStep(
              title: "Notice both feet",
              cue:
                  "Place both feet down. Compare the contact without judging it. Skip any movement that creates discomfort; quiet contact is also a complete practice.",
              seconds: 120),
        ]),
    PracticeSession(
        id: "hand-fan",
        title: "Hand fan",
        subtitle: "Alternate gentle opening and resting without squeezing.",
        kind: "mobility",
        minutes: 12,
        level: "even",
        teaching:
            'Use a comfortable supported position. Follow each cue without forcing a sensation. Pause or stop whenever you need.',
        aims: [
          "stretch",
          "ease"
        ],
        steps: [
          PracticeStep(
              title: "Support the arms",
              cue:
                  "Place your forearms on your thighs or a table. Let the wrists remain comfortable and the shoulders easy. Begin with relaxed hands.",
              seconds: 180),
          PracticeStep(
              title: "Open a little",
              cue:
                  "Spread the fingers slightly, without pulling them straight. Let them return to their resting curve. Try only a few slow repetitions.",
              seconds: 180),
          PracticeStep(
              title: "One hand, then the other",
              cue:
                  "Open one hand while the other rests. Switch sides. Notice the difference in effort and reduce the movement if it becomes tiring.",
              seconds: 180),
          PracticeStep(
              title: "Let the hands settle",
              cue:
                  "Stop moving and support both hands. Notice temperature, contact or nothing in particular. There is no sensation you need to produce.",
              seconds: 180),
        ]),
    PracticeSession(
        id: "side-space",
        title: "Side space",
        subtitle: "A supported seated reach with plenty of room to stop.",
        kind: "yoga",
        minutes: 12,
        level: "even",
        teaching:
            'Use a comfortable supported position. Follow each cue without forcing a sensation. Pause or stop whenever you need.',
        aims: [
          "stretch"
        ],
        steps: [
          PracticeStep(
              title: "Sit comfortably",
              cue:
                  "Sit on a stable chair, feet supported. Rest both hands on your thighs. Make sure there is space beside you and nothing to bump.",
              seconds: 180),
          PracticeStep(
              title: "Slide, do not pull",
              cue:
                  "Let one hand slide a little toward the side of the thigh as your chest tips gently to that side. Return upright. Avoid leaning far or pulling on the chair.",
              seconds: 180),
          PracticeStep(
              title: "Try the other side",
              cue:
                  "Repeat a small motion to the other side. Breathe in your own rhythm. Keep your head comfortable and stop if the motion creates strain.",
              seconds: 180),
          PracticeStep(
              title: "Meet the centre",
              cue:
                  "Rest upright with support. Notice both sides of your body. A smaller motion, or simply imagining the motion while staying still, is enough.",
              seconds: 180),
        ]),
    PracticeSession(
        id: "grounded-reach",
        title: "Grounded reach",
        subtitle: "Move one arm forward while keeping the rest supported.",
        kind: "yoga",
        minutes: 12,
        level: "even",
        teaching:
            'Use a comfortable supported position. Follow each cue without forcing a sensation. Pause or stop whenever you need.',
        aims: [
          "stretch",
          "ease"
        ],
        steps: [
          PracticeStep(
              title: "Arrange support",
              cue:
                  "Sit with feet supported and your back comfortable. Rest your hands on your thighs. Choose a clear area in front of you.",
              seconds: 180),
          PracticeStep(
              title: "Reach below shoulder height",
              cue:
                  "Move one hand forward a little with a soft elbow, staying below shoulder height. Return it to your thigh. Do not lean to gain distance.",
              seconds: 180),
          PracticeStep(
              title: "Alternate and rest",
              cue:
                  "Try the other hand, then pause with both hands down. Repeat at an easy pace. Keep breathing ordinary; omit a side if it feels uncomfortable.",
              seconds: 180),
          PracticeStep(
              title: "End with contact",
              cue:
                  "Rest your hands and feel the support beneath you. Notice whether effort changes after stopping. You do not need to stretch farther next time.",
              seconds: 180),
        ]),
    PracticeSession(
        id: "breath-landmarks",
        title: "Breath landmarks",
        subtitle:
            "Notice a beginning and an ending without controlling either.",
        kind: "breath",
        minutes: 8,
        level: "smooth",
        teaching:
            'Use a comfortable supported position. Follow each cue without forcing a sensation. Pause or stop whenever you need.',
        aims: [
          "ease",
          "sit"
        ],
        steps: [
          PracticeStep(
              title: "Leave the breath alone",
              cue:
                  "Find a comfortable supported position. Do not change the depth or timing of your breath. Notice a contact point to help you settle.",
              seconds: 120),
          PracticeStep(
              title: "Notice a beginning",
              cue:
                  "See if you can notice the beginning of an inhale. Let the rest happen by itself. If following breath is uncomfortable, follow a quiet sound instead.",
              seconds: 120),
          PracticeStep(
              title: "Notice an ending",
              cue:
                  "Notice where an exhale seems to finish. There is no need to pause, hold or count. Let the next breath arrive in its own time.",
              seconds: 120),
          PracticeStep(
              title: "Release the landmarks",
              cue:
                  "Stop tracking beginnings and endings. Feel the room around you and your body's support. Finish whenever you feel ready.",
              seconds: 120),
        ]),
    PracticeSession(
        id: "single-task",
        title: "One thing at a time",
        subtitle:
            "Practice returning attention without turning it into a test.",
        kind: "sit",
        minutes: 18,
        level: "rough",
        teaching:
            'Use a comfortable supported position. Follow each cue without forcing a sensation. Pause or stop whenever you need.',
        aims: [
          "sit",
          "ease"
        ],
        steps: [
          PracticeStep(
              title: "Choose an ordinary anchor",
              cue:
                  "Choose one quiet sound, an object or the contact of a foot. Settle into a position you can change whenever needed.",
              seconds: 270),
          PracticeStep(
              title: "Stay for a moment",
              cue:
                  "Notice one detail of your anchor, then another. Keep the effort light. You are exploring attention, not trying to keep the mind empty.",
              seconds: 270),
          PracticeStep(
              title: "Recognize a detour",
              cue:
                  "When you notice a thought or distraction, silently name it 'a detour'. Return to the anchor once, gently. Wandering is not a failed repetition.",
              seconds: 270),
          PracticeStep(
              title: "Bring it into the day",
              cue:
                  "Let attention widen again. Choose one everyday task to do with a little less hurry. You can return to one detail at any time.",
              seconds: 270),
        ]),
    PracticeSession(
        id: "evening-inventory",
        title: "Evening inventory",
        subtitle: "Notice what is finished without planning the next day.",
        kind: "sleep",
        minutes: 12,
        level: "smooth",
        teaching:
            'Use a comfortable supported position. Follow each cue without forcing a sensation. Pause or stop whenever you need.',
        aims: [
          "sleep",
          "ease"
        ],
        steps: [
          PracticeStep(
              title: "Find an evening position",
              cue:
                  "Sit or lie down with comfortable support. Adjust clothing, light or position if needed. No particular posture is required.",
              seconds: 180),
          PracticeStep(
              title: "Name one finished thing",
              cue:
                  "Recall one ordinary action that is already complete: a meal, a message, a journey. Keep the memory brief and factual.",
              seconds: 180),
          PracticeStep(
              title: "Leave the next thing",
              cue:
                  "If an unfinished task arrives, acknowledge it without solving it here. Return to the feeling of support. Planning can wait until you choose to resume.",
              seconds: 180),
          PracticeStep(
              title: "Close the inventory",
              cue:
                  "Stop reviewing the day. Let sounds and contact come and go. You may end the session awake, drowsy or unchanged; all are acceptable.",
              seconds: 180),
        ]),
    PracticeSession(
        id: "quiet-horizon",
        title: "Quiet horizon",
        subtitle:
            "Let awareness move from the room toward comfortable support.",
        kind: "sleep",
        minutes: 18,
        level: "smooth",
        teaching:
            'Use a comfortable supported position. Follow each cue without forcing a sensation. Pause or stop whenever you need.',
        aims: [
          "sleep"
        ],
        steps: [
          PracticeStep(
              title: "Make a resting place",
              cue:
                  "Choose a supported position, seated or lying down. Let the eyes close only if comfortable. Keep breathing ordinary.",
              seconds: 270),
          PracticeStep(
              title: "Notice the room",
              cue:
                  "Listen to the broad sound of the room. There is no need to follow individual sounds. Allow the room to exist without checking it.",
              seconds: 270),
          PracticeStep(
              title: "Notice the support",
              cue:
                  "Bring attention to a broad area supported by the bed or chair. Let that contact be enough. Shift position whenever you need.",
              seconds: 270),
          PracticeStep(
              title: "Let the practice fade",
              cue:
                  "Release the task of noticing. Rest without waiting for a particular result. If you remain awake, simply end the lesson gently.",
              seconds: 270),
        ]),
  ];
}
