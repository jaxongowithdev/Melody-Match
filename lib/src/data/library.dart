import '../models/practice_models.dart';

class PracticeLibrary {
  static const moods = ['grounded', 'clear', 'quiet', 'unchanged'];
  static const prompts = [
    'What helped you arrive here?',
    'Which detail would you keep from this practice?',
    'Where could you use a little less effort?',
    'What can you leave alone tonight?'
  ];
  static const patterns = <BreathPattern>[
    BreathPattern(
        id: 'four-columns',
        name: 'Four columns',
        teaching:
            'Inhale, pause, exhale, pause: four even phases and four rounds. Follow the rising columns only while the rhythm feels comfortable. Choose a no-hold pattern or return to ordinary breathing whenever you need.',
        rounds: 4,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 4),
          BreathPhase(label: 'Pause full', seconds: 4),
          BreathPhase(label: 'Exhale', seconds: 4),
          BreathPhase(label: 'Pause empty', seconds: 4)
        ]),
    BreathPattern(
        id: 'gentle-glow',
        name: 'Gentle glow',
        teaching:
            'Three counts in and four out, without holds. Keep the breath small and easy. Counting is optional, not a target to meet.',
        rounds: 6,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 3),
          BreathPhase(label: 'Exhale', seconds: 4)
        ]),
    BreathPattern(
        id: 'steady-lantern',
        name: 'Steady lantern',
        teaching:
            'Four counts in, four counts out, with no pause to hold. Stop counting and breathe normally if the pattern requires effort.',
        rounds: 5,
        phases: [
          BreathPhase(label: 'Inhale', seconds: 4),
          BreathPhase(label: 'Exhale', seconds: 4)
        ]),
  ];
  static const poses = <PoseCard>[
    PoseCard(
        id: "texture-anchor",
        name: "A texture anchor",
        aka: "ATTENTION / TOUCH",
        setup:
            "Rest a hand on a comfortable surface and notice one quality without rubbing or testing.",
        breath: "Let breathing remain natural and uncounted.",
        ifThis: "Use a visible colour instead if touch is uncomfortable."),
    PoseCard(
        id: "tiny-orbit",
        name: "A tiny orbit",
        aka: "MOVEMENT / WRIST",
        setup:
            "Support the forearm and trace a small, painless circle with the hand. Rest after a few repetitions.",
        breath: "Breathe in your own rhythm.",
        ifThis:
            "Keep the hand still if any part of the circle is uncomfortable."),
    PoseCard(
        id: "foot-lift",
        name: "A supported foot lift",
        aka: "MOVEMENT / SEAT",
        setup:
            "Sit on a sturdy chair and lift one foot a little. Lower softly before changing sides.",
        breath:
            "Let the breath continue rather than holding it during the lift.",
        ifThis: "Leave both feet down and alternate attention between them."),
    PoseCard(
        id: "quiet-marker",
        name: "A quiet marker",
        aka: "ATTENTION / RETURNING",
        setup:
            "Choose a contact point and silently say 'here' once when attention returns to it.",
        breath: "No breath timing is needed.",
        ifThis:
            "Omit the word and simply notice contact if words feel distracting."),
    PoseCard(
        id: "leave-one-thing",
        name: "Leave one thing",
        aka: "REST / EVENING",
        setup:
            "Choose one task you can stop considering for now. Return to the support of your chair or bed.",
        breath: "Leave the breath alone.",
        ifThis:
            "Skip the task and notice a quiet sound if reflection feels unhelpful."),
  ];
  static const sessions = <PracticeSession>[
    PracticeSession(
        id: "texture-trail",
        title: "Texture trail",
        subtitle: "Let a familiar surface become an attention anchor.",
        kind: "sit",
        minutes: 8,
        level: "smooth",
        aims: ["ease", "sit"],
        teaching:
            "Let a familiar surface become an attention anchor. Use a comfortable position and stop whenever you need.",
        steps: [
          PracticeStep(
              title: "Choose a surface",
              cue:
                  "Sit comfortably and rest a hand on fabric, a table or your own sleeve. Use something ordinary, clean and comfortable to touch.",
              seconds: 120),
          PracticeStep(
              title: "Notice one quality",
              cue:
                  "Without rubbing hard, notice whether the surface feels smooth, woven, cool or warm. A single word is enough; precise description is not required.",
              seconds: 120),
          PracticeStep(
              title: "Change the point of contact",
              cue:
                  "Move the hand a little and rest again. Notice whether the new contact feels different. Keep the arm supported and avoid repeatedly testing for a result.",
              seconds: 120),
          PracticeStep(
              title: "Carry one detail",
              cue:
                  "Let the hand rest naturally. Remember one detail, then let attention widen to the room. A small observation can be your whole practice.",
              seconds: 120),
        ]),
    PracticeSession(
        id: "room-landmarks",
        title: "Room landmarks",
        subtitle: "Orient attention with three ordinary things around you.",
        kind: "sit",
        minutes: 8,
        level: "smooth",
        aims: ["ease", "sit"],
        teaching:
            "Orient attention with three ordinary things around you. Use a comfortable position and stop whenever you need.",
        steps: [
          PracticeStep(
              title: "Meet the room",
              cue:
                  "Find a supported seat and let your eyes rest. Pick a comfortable direction to look, avoiding glare or anything visually demanding.",
              seconds: 120),
          PracticeStep(
              title: "Name a colour",
              cue:
                  "Notice one colour in the room. Let it be a simple fact rather than a judgement. You can use the colour of your clothing if that is easier.",
              seconds: 120),
          PracticeStep(
              title: "Notice a line and a space",
              cue:
                  "Find one edge or line, then an open space nearby. Look softly and blink naturally. Stop looking closely if it feels tiring.",
              seconds: 120),
          PracticeStep(
              title: "Return to where you are",
              cue:
                  "Feel the seat and the floor. Let the landmarks return to the background. You can use a single familiar object to orient yourself another time.",
              seconds: 120),
        ]),
    PracticeSession(
        id: "wrist-orbit",
        title: "Wrist orbit",
        subtitle: "Explore a tiny circle with the forearm supported.",
        kind: "mobility",
        minutes: 8,
        level: "smooth",
        aims: ["stretch", "ease"],
        teaching:
            "Explore a tiny circle with the forearm supported. Use a comfortable position and stop whenever you need.",
        steps: [
          PracticeStep(
              title: "Support the forearm",
              cue:
                  "Place your forearm comfortably on a thigh or table, with the hand free to move. Keep the fingers relaxed and the shoulder easy.",
              seconds: 120),
          PracticeStep(
              title: "Trace a small circle",
              cue:
                  "Make a very small circle at the wrist. Keep the movement slow and painless. Rest after a few circles rather than trying to complete a target.",
              seconds: 120),
          PracticeStep(
              title: "Reverse or change hands",
              cue:
                  "If comfortable, reverse the circle, then rest. Try the other hand. Reduce the range or leave a hand still if it feels strained.",
              seconds: 120),
          PracticeStep(
              title: "Rest both hands",
              cue:
                  "Support both hands and stop moving. Notice any difference in contact or effort. You may finish without feeling a change.",
              seconds: 120),
        ]),
    PracticeSession(
        id: "seated-march",
        title: "Seated march",
        subtitle:
            "Alternate a light foot lift while your chair does the supporting.",
        kind: "mobility",
        minutes: 12,
        level: "even",
        aims: ["stretch", "ease"],
        teaching:
            "Alternate a light foot lift while your chair does the supporting. Use a comfortable position and stop whenever you need.",
        steps: [
          PracticeStep(
              title: "Set a stable base",
              cue:
                  "Sit on a sturdy chair with both feet supported. Keep your hands on the chair or thighs if useful. Make sure there is clear floor space.",
              seconds: 180),
          PracticeStep(
              title: "Lift one foot slightly",
              cue:
                  "Raise one foot just enough to reduce its contact with the floor, then lower it. Keep the body supported and avoid leaning backward.",
              seconds: 180),
          PracticeStep(
              title: "Alternate with pauses",
              cue:
                  "Try the other foot. Alternate slowly, taking a rest between lifts. If lifting is uncomfortable, keep both feet down and simply notice each in turn.",
              seconds: 180),
          PracticeStep(
              title: "Finish with stillness",
              cue:
                  "Place both feet comfortably down. Let the legs rest. Notice the support of the chair rather than trying to hold an ideal posture.",
              seconds: 180),
        ]),
    PracticeSession(
        id: "elbow-windows",
        title: "Elbow windows",
        subtitle:
            "A small opening movement with hands resting on the shoulders.",
        kind: "yoga",
        minutes: 12,
        level: "even",
        aims: ["stretch"],
        teaching:
            "A small opening movement with hands resting on the shoulders. Use a comfortable position and stop whenever you need.",
        steps: [
          PracticeStep(
              title: "Choose a comfortable position",
              cue:
                  "Sit with back support. If comfortable, rest fingertips on the same-side shoulders. Otherwise keep hands on thighs and imagine the movement.",
              seconds: 180),
          PracticeStep(
              title: "Open a little",
              cue:
                  "Let the elbows move slightly outward, below any point of strain. Return to a comfortable position. There is no need to lift them high.",
              seconds: 180),
          PracticeStep(
              title: "Explore one side",
              cue:
                  "Move one elbow at a time through a smaller range. Keep the neck easy and let the breath continue naturally. Stop if there is discomfort.",
              seconds: 180),
          PracticeStep(
              title: "Lower and release",
              cue:
                  "Return hands to thighs and rest. Notice how the arms feel when supported. The resting part belongs to the lesson as much as the movement.",
              seconds: 180),
        ]),
    PracticeSession(
        id: "knee-glide",
        title: "Knee glide",
        subtitle: "Slide a foot gently while keeping your seat stable.",
        kind: "yoga",
        minutes: 12,
        level: "even",
        aims: ["stretch", "ease"],
        teaching:
            "Slide a foot gently while keeping your seat stable. Use a comfortable position and stop whenever you need.",
        steps: [
          PracticeStep(
              title: "Prepare the floor",
              cue:
                  "Use a stable chair and a clear floor. Wear footwear that stays secure. Put both feet in a comfortable position beneath or slightly ahead of the knees.",
              seconds: 180),
          PracticeStep(
              title: "Slide a short distance",
              cue:
                  "Slide one foot a little forward without locking the knee, then back. Keep the foot in contact with the floor and avoid forcing friction.",
              seconds: 180),
          PracticeStep(
              title: "Change sides",
              cue:
                  "Rest, then try the other foot. Keep the distance small and the pelvis supported. Skip the slide if the floor or clothing makes it awkward.",
              seconds: 180),
          PracticeStep(
              title: "Let both legs rest",
              cue:
                  "Return both feet to a supported position. Notice pressure beneath the feet. There is no goal of matching the two sides.",
              seconds: 180),
        ]),
    PracticeSession(
        id: "breath-weather",
        title: "Breath weather",
        subtitle:
            "Observe the quality of a natural breath without adjusting it.",
        kind: "breath",
        minutes: 8,
        level: "smooth",
        aims: ["ease", "sit"],
        teaching:
            "Observe the quality of a natural breath without adjusting it. Use a comfortable position and stop whenever you need.",
        steps: [
          PracticeStep(
              title: "Begin with support",
              cue:
                  "Sit or lie down comfortably. Notice the support beneath you first. There is no need to deepen, slow or count the breath.",
              seconds: 120),
          PracticeStep(
              title: "Choose a simple description",
              cue:
                  "If comfortable, notice whether a breath feels smooth, uneven, light or ordinary. Treat the word as a passing observation, not an assessment.",
              seconds: 120),
          PracticeStep(
              title: "Let the next one differ",
              cue:
                  "Allow the next breaths to have their own qualities. Avoid checking every breath. Use contact with a surface instead if breath attention feels uncomfortable.",
              seconds: 120),
          PracticeStep(
              title: "Drop the description",
              cue:
                  "Leave the words behind. Feel the body supported and allow breathing to remain in the background. Nothing needs correcting before you finish.",
              seconds: 120),
        ]),
    PracticeSession(
        id: "return-markers",
        title: "Return markers",
        subtitle:
            "Use a simple word to make returning attention less complicated.",
        kind: "sit",
        minutes: 18,
        level: "rough",
        aims: ["sit", "ease"],
        teaching:
            "Use a simple word to make returning attention less complicated. Use a comfortable position and stop whenever you need.",
        steps: [
          PracticeStep(
              title: "Pick an anchor",
              cue:
                  "Choose one stable contact point, such as your back against the chair. Adjust your position so you do not need to work hard to stay here.",
              seconds: 270),
          PracticeStep(
              title: "Use a quiet marker",
              cue:
                  "When you notice the contact, silently say 'here' once. Let the word fade and notice the sensation without repeating the word constantly.",
              seconds: 270),
          PracticeStep(
              title: "Welcome a return",
              cue:
                  "If attention wanders, use 'here' once more and return to contact. There is no need to trace where your attention went or count the returns.",
              seconds: 270),
          PracticeStep(
              title: "Leave the marker behind",
              cue:
                  "Stop using the word and let attention widen. Notice the room and move gently before continuing your day. Returning can be brief and ordinary.",
              seconds: 270),
        ]),
    PracticeSession(
        id: "gentle-endings",
        title: "Three gentle endings",
        subtitle: "Close an evening reflection with three simple observations.",
        kind: "sleep",
        minutes: 12,
        level: "smooth",
        aims: ["sleep", "ease"],
        teaching:
            "Close an evening reflection with three simple observations. Use a comfortable position and stop whenever you need.",
        steps: [
          PracticeStep(
              title: "Choose support",
              cue:
                  "Find a comfortable evening position. Let the eyes stay open or close naturally. Adjust light, clothing and support if needed.",
              seconds: 180),
          PracticeStep(
              title: "Something received",
              cue:
                  "Recall one ordinary thing you received today: water, food, help or a place to sit. No gratitude exercise is required; just acknowledge the fact.",
              seconds: 180),
          PracticeStep(
              title: "Something given",
              cue:
                  "Recall one small action you offered, including care for yourself. Keep it brief. If nothing comes to mind, return to the feeling of support.",
              seconds: 180),
          PracticeStep(
              title: "Something left",
              cue:
                  "Name one thing you can leave alone for now. Stop reviewing the day and rest. The reflection does not need a tidy or positive conclusion.",
              seconds: 180),
        ]),
    PracticeSession(
        id: "resting-outline",
        title: "Resting outline",
        subtitle: "Let broad body awareness become less detailed as you rest.",
        kind: "sleep",
        minutes: 18,
        level: "smooth",
        aims: ["sleep"],
        teaching:
            "Let broad body awareness become less detailed as you rest. Use a comfortable position and stop whenever you need.",
        steps: [
          PracticeStep(
              title: "Arrange a resting place",
              cue:
                  "Sit or lie down with comfortable support. Use a pillow or folded fabric if useful. Change position whenever needed.",
              seconds: 270),
          PracticeStep(
              title: "Notice broad regions",
              cue:
                  "Notice the general presence of the legs, then the arms, without scanning every part. Keep attention light and avoid searching for a particular sensation.",
              seconds: 270),
          PracticeStep(
              title: "Feel the whole outline",
              cue:
                  "Let awareness include the body as a whole. You do not need a clear image. If this feels effortful, listen to a neutral sound instead.",
              seconds: 270),
          PracticeStep(
              title: "Release the outline",
              cue:
                  "Stop following any sequence. Rest in whatever position is comfortable. Falling asleep is not a task, and staying awake is not a failure.",
              seconds: 270),
        ]),
  ];
}
