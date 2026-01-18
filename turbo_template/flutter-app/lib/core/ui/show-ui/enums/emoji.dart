enum Emoji {
  ghost,
  fire,
  shaka,
  heartOnFire,
  explosion,
  flexedBiceps,
  thumbsUp,
  okHand,
  clappingHands,
  raisingHands,
  eyes,
  link,
  calendar,
  magnifyingGlass,
  prostheticLeg,
  camera,
  sparkles,
  fireDuplicate,
  gift,
  speakingHead,
  magicWand,
  unicorn,
  runningShoe,
  barbell,
  stopwatch,
  danger,
  checkMark,
  trophy,
  mapPin,
  groupOfPeople,
  chatBubble,
  mobilePhone,
  ticket,
  nutrition,
  pencil,
  blackNib,
  fountainPen,
  pen,
  paintbrush,
  crayon,
  note,
  clipboard,
  fileFolder,
  openFileFolder,
  barChart,
  chartIncreasing,
  chartDecreasing,
  paperclip,
  pageWithCurl,
  pageFacingUp,
  wastebasket,
  straightRuler,
  triangularRuler,
  pushpin,
  roundPushpin,
  ledger,
  orangeBook,
  greenBook,
  blueBook,
  notebook,
  notebookWithDecorativeCover,
  newsPaper,
  house,
  prize,
  contacts,
  wavingHand,
  email,
  shakingHands,
  whiteHeart,
  heart,
  goal,
  cloud,
  calculator,
  idea,
  floppy,
  cog,
  tomato,
  account,
  payments,
  courses,
  roadmap,
  theFeatures,
  theWorkshop,
  theArchive,
  theMailbox,
  lastNote,
  quickActions,
  cross,
  world,
  warning,
  tasks,
  dove,
  filter,
  time,
  magic,
  paradise,
  outOfTime,
  allTodos,
  add,
  logs,
  candle,
  ice,
  snow,
  robot,
  snowMan,
  wolf,
  snooze,
  profile,
  party,
  wonder,
  hug,
  openBook,
  present,
  happyBlush,
  sweat,
  finishLine,
  poker,
  collections,
  clown,
  snoozeAll,
  wood,
  tag,
  pin,
  deadline,
  oldestTasks,
  start,
  end,
  duration,
  tools,
  star,
  rocket,
  lightBulb,
  clock,
  bell,
  lock,
  key,
  hammer,
  wrench,
  gear,
  flag,
  target,
  medal,
  crown,
  money,
  creditCard,
  shoppingCart,
  package,
  airplane,
  car,
  bus,
  train,
  bicycle,
  umbrella,
  sun,
  moon,
  rainbow,
  earth,
  mountain,
  tree,
  flower,
  leaf,
  seedling,
  recycle,
  battery,
  plug,
  computer,
  smartphone,
  tv,
  videoCamera,
  microphone,
  headphones,
  speaker,
  megaphone,
  envelope,
  inbox,
  outbox,
  folder,
  trashCan,
  graph,
  chart,
  bug,
  testTube,
  label,
  bookmark,
  thoughtBubble,
  brain,
  document,
  bookmarkTabs,
  cleaning,
  myCleaningTasks,
  allCleaningTasks,
  shoppingBag,
  broom,
  bucket,
  construction;

  String get id => name;

  @override
  String toString() {
    switch (this) {
      case Emoji.ghost:
        return '👻';
      case Emoji.fire:
        return '🔥';
      case Emoji.shaka:
        return '🤙';
      case Emoji.heartOnFire:
        return '❤️‍🔥';
      case Emoji.explosion:
        return '💥';
      case Emoji.flexedBiceps:
        return '💪';
      case Emoji.thumbsUp:
        return '👍';
      case Emoji.okHand:
        return '👌';
      case Emoji.clappingHands:
        return '👏';
      case Emoji.raisingHands:
        return '🙌';
      case Emoji.eyes:
        return '👀';
      case Emoji.link:
        return '🔗';
      case Emoji.calendar:
        return '📆';
      case Emoji.magnifyingGlass:
        return '🔎';
      case Emoji.prostheticLeg:
        return '🦿';
      case Emoji.camera:
        return '📸';
      case Emoji.sparkles:
        return '💫';
      case Emoji.fireDuplicate:
        return '🔥';
      case Emoji.gift:
        return '🎁';
      case Emoji.speakingHead:
        return '🗣️';
      case Emoji.magicWand:
        return '🪄';
      case Emoji.unicorn:
        return '🦄';
      case Emoji.runningShoe:
        return '👟';
      case Emoji.barbell:
        return '🏋';
      case Emoji.stopwatch:
        return '⏱️';
      case Emoji.checkMark:
        return '✅';
      case Emoji.trophy:
        return '🏆';
      case Emoji.mapPin:
        return '📍';
      case Emoji.groupOfPeople:
        return '👥';
      case Emoji.chatBubble:
        return '💬';
      case Emoji.mobilePhone:
        return '📱';
      case Emoji.ticket:
        return '🎟️';
      case Emoji.nutrition:
        return '🥗';
      case Emoji.pencil:
        return '✏️';
      case Emoji.blackNib:
        return '✒️';
      case Emoji.fountainPen:
        return '🖋️';
      case Emoji.pen:
        return '🖊️';
      case Emoji.paintbrush:
        return '🖌️';
      case Emoji.crayon:
        return '🖍️';
      case Emoji.note:
        return '📝';
      case Emoji.clipboard:
        return '📋';
      case Emoji.fileFolder:
        return '📁';
      case Emoji.openFileFolder:
        return '📂';
      case Emoji.barChart:
        return '📊';
      case Emoji.chartIncreasing:
        return '📈';
      case Emoji.chartDecreasing:
        return '📉';
      case Emoji.paperclip:
        return '📎';
      case Emoji.pageWithCurl:
        return '📃';
      case Emoji.pageFacingUp:
        return '📄';
      case Emoji.wastebasket:
        return '🗑️';
      case Emoji.straightRuler:
        return '📏';
      case Emoji.triangularRuler:
        return '📐';
      case Emoji.pushpin:
        return '📌';
      case Emoji.roundPushpin:
        return '📍';
      case Emoji.ledger:
        return '📘';
      case Emoji.orangeBook:
        return '📙';
      case Emoji.greenBook:
        return '📗';
      case Emoji.blueBook:
        return '📘';
      case Emoji.notebook:
        return '📔';
      case Emoji.notebookWithDecorativeCover:
        return '📕';
      case Emoji.newsPaper:
        return '📰';
      case Emoji.house:
        return '🏠';
      case Emoji.prize:
        return '🏆';
      case Emoji.contacts:
        return '👥';
      case Emoji.wavingHand:
        return '👋';
      case Emoji.email:
        return '✉️';
      case Emoji.shakingHands:
        return '🤝';
      case Emoji.whiteHeart:
        return '🤍';
      case Emoji.heart:
        return '❤️';
      case Emoji.goal:
        return '🎯';
      case Emoji.cloud:
        return '☁️';
      case Emoji.calculator:
        return '🧮';
      case Emoji.idea:
        return '💡';
      case Emoji.floppy:
        return '💾';
      case Emoji.cog:
        return '⚙️';
      case Emoji.tomato:
        return '🍅';
      case Emoji.account:
        return '👤';
      case Emoji.payments:
        return '💳';
      case Emoji.courses:
        return '🎓';
      case Emoji.roadmap:
        return '🚀';
      case Emoji.theFeatures:
        return '✨';
      case Emoji.theWorkshop:
        return '🏛️';
      case Emoji.theArchive:
        return '🗄️';
      case Emoji.theMailbox:
        return '📬';
      case Emoji.lastNote:
        return '🎵';
      case Emoji.quickActions:
        return '⚡';
      case Emoji.world:
        return '🌎';
      case Emoji.cross:
        return '❌';
      case Emoji.danger:
        return '⛔️';
      case Emoji.warning:
        return '⚠️';
      case Emoji.tasks:
        return '📋';
      case Emoji.dove:
        return '🕊️';
      case Emoji.filter:
        return '🧹';
      case Emoji.time:
        return '⏳';
      case Emoji.magic:
        return '✨';
      case Emoji.paradise:
        return '🏝️';
      case Emoji.outOfTime:
        return '⌛️';
      case Emoji.allTodos:
        return '📝';
      case Emoji.add:
        return '➕';
      case Emoji.logs:
        return '🪵';
      case Emoji.candle:
        return '🕯️';
      case Emoji.ice:
        return '🧊';
      case Emoji.snow:
        return '❄️';
      case Emoji.robot:
        return '🤖';
      case Emoji.snowMan:
        return '⛄';
      case Emoji.wolf:
        return '🐺';
      case Emoji.snooze:
        return '💤';
      case Emoji.profile:
        return '👤';
      case Emoji.party:
        return '🎉';
      case Emoji.wonder:
        return '🤔';
      case Emoji.hug:
        return '🤗';
      case Emoji.openBook:
        return '📖';
      case Emoji.present:
        return '🎁';
      case Emoji.happyBlush:
        return '😊';
      case Emoji.sweat:
        return '😅';
      case Emoji.finishLine:
        return '🏁';
      case Emoji.poker:
        return '🃏';
      case Emoji.collections:
        return '🪐';
      case Emoji.clown:
        return '🤡';
      case Emoji.snoozeAll:
        return '🕰️';
      case Emoji.wood:
        return '🪵';
      case Emoji.tag:
        return '🏷️';
      case Emoji.pin:
        return '📍';
      case Emoji.deadline:
        return '⏳';
      case Emoji.oldestTasks:
        return '📜';
      case Emoji.start:
        return '🎬';
      case Emoji.end:
        return '🏁';
      case Emoji.duration:
        return '⏱️';
      case Emoji.tools:
        return '🛠️';
      case Emoji.star:
        return '⭐';
      case Emoji.rocket:
        return '🚀';
      case Emoji.lightBulb:
        return '💡';
      case Emoji.clock:
        return '🕰️';
      case Emoji.bell:
        return '🔔';
      case Emoji.lock:
        return '🔒';
      case Emoji.key:
        return '🔑';
      case Emoji.hammer:
        return '🔨';
      case Emoji.wrench:
        return '🔧';
      case Emoji.gear:
        return '⚙️';
      case Emoji.flag:
        return '🚩';
      case Emoji.target:
        return '🎯';
      case Emoji.medal:
        return '🏅';
      case Emoji.crown:
        return '👑';
      case Emoji.money:
        return '💰';
      case Emoji.creditCard:
        return '💳';
      case Emoji.shoppingCart:
        return '🛒';
      case Emoji.package:
        return '📦';
      case Emoji.airplane:
        return '✈️';
      case Emoji.car:
        return '🚗';
      case Emoji.bus:
        return '🚌';
      case Emoji.train:
        return '🚂';
      case Emoji.bicycle:
        return '🚲';
      case Emoji.umbrella:
        return '☂️';
      case Emoji.sun:
        return '☀️';
      case Emoji.moon:
        return '🌙';
      case Emoji.rainbow:
        return '🌈';
      case Emoji.earth:
        return '🌍';
      case Emoji.mountain:
        return '⛰️';
      case Emoji.tree:
        return '🌳';
      case Emoji.flower:
        return '🌸';
      case Emoji.leaf:
        return '🍃';
      case Emoji.seedling:
        return '🌱';
      case Emoji.recycle:
        return '♻️';
      case Emoji.battery:
        return '🔋';
      case Emoji.plug:
        return '🔌';
      case Emoji.computer:
        return '💻';
      case Emoji.smartphone:
        return '📱';
      case Emoji.tv:
        return '📺';
      case Emoji.videoCamera:
        return '📹';
      case Emoji.microphone:
        return '🎙️';
      case Emoji.headphones:
        return '🎧';
      case Emoji.speaker:
        return '🔊';
      case Emoji.megaphone:
        return '📢';
      case Emoji.envelope:
        return '✉️';
      case Emoji.inbox:
        return '📥';
      case Emoji.outbox:
        return '📤';
      case Emoji.folder:
        return '📁';
      case Emoji.trashCan:
        return '🗑️';
      case Emoji.graph:
        return '📊';
      case Emoji.chart:
        return '📉';
      case Emoji.bug:
        return '🐛';
      case Emoji.testTube:
        return '🧪';
      case Emoji.label:
        return '🏷️';
      case Emoji.bookmark:
        return '🔖';
      case Emoji.thoughtBubble:
        return '💭';
      case Emoji.brain:
        return '🧠';
      case Emoji.document:
        return '📄';
      case Emoji.bookmarkTabs:
        return '📑';
      case Emoji.cleaning:
        return '🧽';
      case Emoji.myCleaningTasks:
        return '📌';
      case Emoji.allCleaningTasks:
        return '📋';
      case Emoji.shoppingBag:
        return '🛍️';
      case Emoji.broom:
        return '🧹';
      case Emoji.bucket:
        return '🪣';
      case Emoji.construction:
        return '🚧';
    }
  }
}
