// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:single_read/main.dart';

// void main() async {
//   await test();
//   //await testXml();
//   //await analyzeArticleContentTags();
// }

// Future<void> analyzeArticleContentTags() async {
//   final Model model = Model();
//   List<Article> allArticles = [];
//   Map<String, List<String>> allTags = {};
//   for (int page = 1; page <= 3; page++) {
//     List<Article> articles = await model.getArticles(page: page);
//     for (Article article in articles) {
//       //print("article_id:${article.id}");
//       if (article.id != null) {
//         await model.loadArticleDetail(article);
//       }
//     }
//     allArticles.addAll(articles);
//   }

//   for (Article article in allArticles) {
//     //parse content
//     if (article.content != null && article.content.isNotEmpty) {
//       print('parse tags from [${article.id}]');
//       Map<String, int> tags = {};
//       var document = parse('<root>${article.content}</root>');
//       document.descendants.forEach((XmlNode node) {
//         if (node is XmlElement) {
//           String tagName = node.name.toString();
//           if (tags.containsKey(tagName)) {
//             tags[tagName] += 1;
//           } else {
//             tags[tagName] = 1;
//           }
//         }
//       });
//       //print('[${article.id}, $tags]');
//       for (String tag in tags.keys) {
//         if (!allTags.containsKey(tag)) {
//           allTags[tag] = [article.id];
//         } else {
//           allTags[tag].add(article.id);
//         }
//       }
//     }
//   }

//   for (String tag in allTags.keys) {
//     print('$tag: ${allTags[tag]}');
//   }
// }

// Future<void> testXml() async {
//   var xmlStr = '''
//   <h2 style="white-space: normal;">
//     <strong>
//     </h2>
//     <p>
//         <img src="http://img.owspace.com/Public/uploads/Editor/2019-12-05/1575550912888995.jpeg" width="1000" height="260" />
//     </p>
//     <h2></h2>
//     <p>
//         <img src="http://img.owspace.com/Public/uploads/Editor/2019-12-05/1575550921719847.jpeg" width="1080" height="62" />
//     </p>
//     <h2>
//     </strong>
//     <strong>那些忧伤的年轻人</strong>
// </h2>
// <p style="white-space: normal;">
//     <span style="color: rgb(127, 127, 127);">我探求的并非一个日期，而是一个象征，一个转折点，一个我们被歪曲的道德历史进程中的隐秘时刻。</span>
// </p>
// <p style="white-space: normal;">
//     <span style="color: rgb(127, 127, 127);">——莫里斯·迪克斯坦《伊甸园之门》</span>
// </p>
// <p style="white-space: normal;">
//     <span style="color: rgb(127, 127, 127);">这是一个轻松、急速、冒险的时代，在这个时代中度过青春岁月是愉快的；可是走出这个时代却使人感到欣慰，就像从一间人挤得太多、讲话声太嘈杂的房间里走出来到冬日街道上的阳光中一样。</span>
// </p>
// <p style="white-space: normal;">
//     <span style="color: rgb(127, 127, 127);">——迈克尔·考利《流放者的归来》</span>
// </p>
// <p style="white-space: normal;">四年以后，我仍然清晰记忆着李皖给我带来的震惊。“这一年，高晓松 27 岁，但已经开始回忆。” 1997 年的秋天，我斜躺在北京大学 28 楼 202 宿舍里，这句话从《读书》杂志粗糙的纸张中跳出来，柔情似水却准确有力地抓住了我涣散的神情。“这么早就回忆了”，李皖在感慨的同时，开始寻找隐藏在一代人“怀旧”面具后的秘密。</p>
// <p style="white-space: normal;">这是一个逃课的上午，屋内微冷，校园的树叶变得金黄，并逐渐飘落。这一年，我 21 岁，三年级学生，满脸的迷惘与偶尔的愤怒，四处表现着对当时北大的不满。压抑，是我当时最喜欢的措辞，被随时用来形容我的青春与校园生活。自从 1995 年进入北大，一种致命的平庸与现世感就死死地围困着我。周围的同学要么疯狂学习，努力成为国内外的研究生；要么就终日无所事事，通过玩电脑游戏消磨时光；还有一少部分乐此不疲地加入以舞厅与录像厅（或许还有学生会）为核心的社交场所……也在 1995 年，微软发布了 Windows 95 ，并被扯进了一场似乎无法结束的反垄断官司；而一家叫网景的公司创造了股票市场奇迹，那个有着娃娃脸的叫马克·安德森的年轻人，当天就成为亿万富翁，“ .com ”狂飙运动开始了；七大工业国还在这一年通过兴建“信息高速公路”的协议，决定共同促进“信息社会”的早日来临……到了 1997 年，多利羊出场，戴安娜随风逝去，连《泰坦尼克号》这样的片子都大获成功……</p>
// <p style="white-space: normal;">
//     <img src="http://img.owspace.com/Public/uploads/Editor/2019-12-05/1575550812251457.jpeg" width="630" height="832" />
// </p>
// <h5 style="white-space: normal;">1996 年，马克·安德森登上了《时代》杂志封面</h5>
// <p style="white-space: normal;">当然，我并未意识到这些事件预示着的社会变革，张朝阳、丁磊神话还要过几年才出现。为了躲避不满与愤怒，我让自己沉浸在幻想里，幻想中最常见的场景就是“这么早就回忆了”的 80 年代校园。高中时看到的《女大学生宿舍》奠定了幻想的基础，这部蹩脚与幼稚的电影有效地挑逗起少年人心中“担当社会责任”的激情，部分准确地把握了 80 年代初期中国大学内四处洋溢的求知与变革热情。83 级的学生孔庆东用他的亲身体验将我的幻想推向极致。在他如金庸笔法的描述下，80 年代校园成了一个奇情的江湖。形形色色的年轻人充斥其中，不断涌入的新思潮搅拌在一起：哲学上的存在主义、诗歌中的现代派、艺术上的实验行为，还有荷尔蒙刺激下的青春式自命不凡毫无顾忌地融合在一起……这是一个青春绽放的年代，生命中的狂喜被眼花缭乱的变幻从内心深处激发出来—他们在热爱顾城与北岛不久，就迅速宣称打倒他们；他们刚刚读了 20 页的《存在与虚无》，就又要排队去购买尼采；中央美院的孩子们为了表现自己的艺术热情，开着大轿车来到北大食堂前，把一桶桶涂料往身上倒……诗歌与哲学是那个时代的通行证，就像 86 级学生李方回忆的，他流浪到内蒙古大学，饥饿逼迫他踹开一间宿舍的门，然后大声嚷道，我是北京来的诗人，我要吃肉，然后他就受到了热情招待。北大的三角地经常会贴着“以论文会友”的广告，据说像几百年前的“比武招亲”一样受欢迎…… 1998 年出版的《北大往事》将这种神话导向巅峰。多年以后，那些当初的年轻人满怀喜悦与忧伤地将自己的少年意气与琐碎倾倒出来，结果那些忧郁的碎片再次让他们陶醉之后，也征服了我这样的后来者。</p>
// <p style="white-space: normal;">回到 1997 年秋天的那本《读书》，李皖在粗糙的纸面上继续以高晓松为例探寻着“ 60 年代人气质”。许晖最初提出了这一命题，这个浸透忧伤的年轻人固执地认为，出生于 60 年代的人是过渡的一代，他们赶上了一个激荡时代的尾巴。前一代有沉重的历史碎片咀嚼，而后一代即 70 年代人则毫无历史负担。漫游的气质，是李皖认定的 60 年代人主要的共通点，他们的童年是在没人管的田野中的闲荡；而他们最重要的青春期�������在 80 年代中后期的大学校园中度过的，彼时的校园才子才女如云，好一个白衣飘飘的年代；而毕业后他们遭遇了社会巨变，经济与技术变革否定了闲荡的气质，让他们无所适从……</p>
// <p style="white-space: normal;">我正是在这样一个极度缺乏浪漫气质的时代进入校园的。在我热烈地猜想着 80 年代校园时，李皖告诉我高晓松的音乐令我沉醉的原因。一方面它是小布尔乔亚情调的，另一方面它是豪情灼人的。啊，我几乎要惊呼起来了，这已经精确地道明了贯穿于 80 年代的校园与 60 年代年轻人间的气质。</p>
// <p style="white-space: normal;">无疑，我在第三段手舞足蹈描述的是80年代校园中豪情壮志的一面，它属于 80 年代前半期。对于中国社会来讲，几十年的压抑情绪在那短短几年中以不可阻挡之势爆发出来，一种单纯的理想主义鼓舞着人们投身于新时代。对于此时进入大学的青年来说，他们是中国最受瞩目的群体，在集体抒情中度过的童年更让他们赋予自我一种惊人的使命感。他们愿意认为自己身处中国第二次启蒙运动之中，此时的北大正是蔡元培精神的延续。</p>
// <p style="white-space: normal;">
//     <img src="http://img.owspace.com/Public/uploads/Editor/2019-12-05/1575550812403989.jpeg" width="1080" height="683" />
// </p>
// <h5 style="white-space: normal;">北大学生集资铸造的蔡元培铜像，位于未名湖畔的钟亭下</h5>
// <p style="white-space: normal;">我承认在最初的大学生活中，我将年轻人的躁动与承担历史使命的激情混为一谈。二十岁的年纪，把叛逆与喧嚣视作青春的唯一亮色。我时常假想着 20 年代的北大。我不理解蔡元培与胡适为何反感学生罢课，我只是觉得那么多青年聚集在街上群情振奋就一定是对的，而且很富戏剧感。所以，我喜欢 80 年代闹哄哄的校园生活。我清晰地记得我是如此着迷于北大的嘘声与大讲堂门口的拥挤与混乱。我将这两者都视作 80 年代校园精神的延续，并为它们的最终消失而惋惜不已。</p>
// <p style="white-space: normal;">90 年代的校园是令人失望的。越来越强势、越来越标准化的应试教育让入学的年轻人越来越同质与乏味。我们生于 70 年代，已经不可能再有那些集体忧伤与歌唱的兴趣，同时，我们可怜的个人主义却没有机会真正成长起来，甚至滑向了极度自私的一面。小布尔乔亚情调成了我这样的年轻人最后的救命稻草。尽管内心深处可能更加渴望波澜壮阔的场面，但是现实却最多让我选择琴弦与姑娘作为区分我与庸众的标志。高晓松的怀旧所代表的 80 年代末大学校园的风花雪月精妙地切入了我的内心，令我回避了洋溢在 90 年代的实利主义。</p>
// <p style="white-space: normal;">
//     <img src="http://img.owspace.com/Public/uploads/Editor/2019-12-05/1575550812798247.jpeg" width="634" height="378" />
// </p>
// <h5 style="white-space: normal;">青年时代的高晓松</h5>
// <p style="white-space: normal;">相当长的一段时间里，我让自己堕入许晖、李皖、高晓松这些 80 年代学生营造的忧伤氛围中。我像他们一样喜欢回忆自己尚不丰富的人生，并以此为傲。但最终我发现自己实在无可追忆，这种追忆也很容易演变为自怜自艾。在离开学校之前，我开始阅读《伊甸园之门》与《流放者归来》。</p>
// <p style="white-space: normal;">前者是李皖所代表的 80 年代大学生的“圣经”。莫非他们在乱哄哄的 60 年代美国的记述中，看到了自己青春的时光？鲍勃·迪论是他们的崔健；艾伦·金斯堡是他们的北岛；美国青年热爱嬉皮士打扮，他们则穿起了牛仔裤、留起了披肩发；美国青年们在旧金山、在伍德斯托克上为生命自由与音乐而狂喜，他们则沉醉于罗大佑与齐秦，在大街上、在琴弦上寂寞成长；美国姑娘们习惯于用避孕药，而他们则开始翻阅琼瑶与《曼娜回忆录》；美国青年们人手一册马尔库塞与麦克卢汉，他们则言必称萨特与弗洛伊德；圆明园的画家村就是他们的格林尼治村……这两个时代都蕴含了青春的喧闹，但是 60 年代的美国更意味着“青年文化”的成熟，年轻人不再仅仅是成熟道路上的一个过程、一个亚文化群体，他们是独立社会组成。但是，80 年代的中国青年却没有传达出这种声音，他们要么让自己依附于历史理想，要么陷入自我的狭隘情感。更重要的是，他们尚未有时间与条件构造出自己的知识结构，让激情变为思想，让情感富有韧性。 </p>
// <p style="white-space: normal;">喧闹的 60 年代美国，实际上也在宣称自己文化的真正成熟。那个年代，欧洲国家已经不能再宣称美国毫无文化与艺术了。塞林格、凯鲁亚克、卡波特这样的小说家已经成为欧美批评界共同关注的对象，特里林、苏珊·桑塔格这样的批评家已成为公认的学术明星，而即使像安迪·沃霍尔那样的波普艺术家显然也已是新的时尚，更不用提好莱坞电影这样的大众文化了……当然，你可以说这种强势文化背后是美国强大的经济能力。但我们同样无法忽略美国的文学艺术人士在其中的不懈努力。</p>
// <p style="white-space: normal;">
//     <img src="http://img.owspace.com/Public/uploads/Editor/2019-12-05/1575550813710992.jpeg" width="640" height="426" />
// </p>
// <h5 style="white-space: normal;">上世纪 60 年代，一大批向往自由、充满美好愿景的美国青年开始沉迷于嬉皮士文化（hippies）</h5>
// <p style="white-space: normal;">我更觉得中国的 80 年代相似于 1890 年的美国。这是美国文化开始崛起的过程。在此之前，爱默生早在 1850 年起就不断呼吁“美国精神的觉醒”，美国人不能总是依靠阅读英国小说、在欧洲文化的压抑下成长。尽管有沃尔特·惠特曼、爱伦·坡、麦尔维尔的努力，但是美国文化依旧在沉睡。19 世纪 90 年代，是美国第一次试图大规模引进欧洲文化标准的时期，比如亨利·詹姆斯，一代美国青年如德莱塞等也在不懈努力。此时的美国正在面临城市化的过程，“生活的全面商品化”是当时的趋势。当时的美国公众更喜欢赫斯特的煽情新闻而非文学艺术……我认为 80 年代的中国与之相似并非因为这些细节，而是 80 年代所蕴涵的强烈“过渡”色彩。生于 60 年代、成熟于 80 年代的那一代，他们的青年时期处在一个引入外来文化的最初阶段，他们惊喜于那些思想，却没有时间吸收。但正是这大量有待清理的思想，为后来发展提供了奠基，他们才是真正的“迷惘一代”。</p>
// <p style="white-space: normal;">终于，我们来到了迈克尔·考利描绘的 20 世纪 20 年代美国。在我有限的阅读历史中，还有什么比《流放者的归来—— 20 年代的文学流浪生涯》更能表现一个年轻人的忧伤与快乐吗？在我寻找青春力量的过程中，这本书比起《北大往事》、《伊甸园之门》，还有那本最新出版的《“60 年代”气质》更为公正与积极地描述了青春的气质。</p>
// <p style="white-space: normal;">这群被格鲁特·斯泰因称作“迷惘一代”的年轻人出生于上个世纪初，在田野与大地成长，上大学时他们幼时的乡村童年开始消失；他们中有的热爱文学，住进了廉价的格林尼治村，在那里编辑《扫帚》、《转盘》这样的小杂志；然后一次世界大战来了，他们被扔到了欧洲，在那里花着别的国家的钱，学会调情、酗酒与不负责任，看到了死亡随时与自己擦身而过……在去欧洲之前，他们看到 30 个美国知识分子写的《美国文明》，不断有人告诉他们，美国一无是处，是缺乏“ 50 个最有才智的人”的英国。《美国文明》的主编哈罗德·斯特恩自问自答道，美国年轻人该怎么办？到欧洲去，到欧洲去。</p>
// <p style="white-space: normal;">战后，他们开始流放自己，去巴黎，那里是文学与艺术的中心。他们拼命地学习福楼拜、学习普鲁斯特。他们有年轻的记者海明威、有忧伤的菲茨杰拉德、有激进的帕索斯、有喜欢热闹的迈克尔·考利，还有一大批有二三流才智但无比热情的美国青年，他们喝苦艾酒、在咖啡馆里争论，他们都努力地写作，努力地学习欧洲蕴含的意境。</p>
// <p style="white-space: normal;">他们当然是一小部分，国内的青年们正在爵士乐中快乐无比，汽车是新的追逐对象，通讯领域正在发生由一家叫 AT&T 公司领导的革命，广播、电影开始普及，那些不怎么样的文学青年变成了广告撰稿人，无意中推动着新商业革命。然后，这些巴黎浪子们回国了。他们发现自己和自己的小说一下子变成了时代的代言人。《了不起的盖茨比》是那些受过良好教育的工商青年精英们最爱的爵士时代的伟大小说；谁都在学习《太阳照样升起》中男主人公坚硬、干脆的讲话方式；帕索斯更加雄心勃勃，干脆开始记录起一个时代——《美国》三部曲；即使那个被海明威不屑的迈克尔·考利不也成为《新共和》杂志的书评编辑了吗？他后来写作的《流放者的归来》，鼓舞了几代文学青年的成长。</p>
// <p style="white-space: normal;">“迷惘一代”的作家们在三十岁左右就成了国际知名人士。1930 年，美国人甚至第一次得到了诺贝尔文学奖。尽管辛克莱·刘易斯在《大街》里的表现不尽如人意，他的年纪也大了一些，也尽管他的获奖更多是由于美国经济、政治地位的崛起，但是谁又能否认，此时由“迷惘一代”们创造的美国文化已经开始摆脱幼稚了呢？一方面，他们要感谢“到欧洲去，到欧洲去”的伟大号召，另一方面也应该感谢 19 世纪 90 年代那批人为他们做出的牺牲。文学批评家拉泽尔·奇夫认为，20 年代“迷惘的一代”作家之所以被人发现与接受，是因为他们引起的巨大社会震动的后果在很大程度上已经由 19 世纪 90 年代那些作家代为受过了。那些今天已经被人遗忘的名字与青年，成为海明威的垫脚石，前者比后者更加迷惘。</p>
// <p style="white-space: normal;">
//     <img src="http://img.owspace.com/Public/uploads/Editor/2019-12-05/1575550813675278.jpeg" width="974" height="636" />
// </p>
// <h5 style="white-space: normal;">欧内斯特·海明威（左）和格特鲁德·斯坦因（右），斯泰因曾在与海明威的对话中说：“你们都是迷惘的一代。”</h5>
// <p style="white-space: normal;">许晖讲的没有错，他们的确是过渡的一代，新出的那本《“ 60 年代”气质》中无处不在的忧伤与被牺牲感，不断地强调着这一点。但谁又不身处过渡之中呢？只是对于中国来讲，海明威那一代何时才会出现呢？从 1890 年到 1920 年，整整三十年间，那一代青年同样是过渡，在等待辉煌。</p>
// <p style="white-space: normal;">距离 1997 年的秋天已将近四年了。我对于 80 年代大学校园的憧憬情感在 1998 年的《北大往事》后开始褪色。所以，《“ 60 年代”气质》这样书令我感慨，却不再感动。我渴望这些已过而立之年的青年们，除了回忆与唏嘘之外，能让人看到一些更富建设性的作品。他们像考利一样编辑过《我们》、《今天》等形形色色的杂志，他们也在贫穷与喧嚣还有醉酒中庆祝自己的青春与写作，而现在我渴望看到他们的《太阳照样升起》与《流放者归来》。</p>
// <p style="white-space: normal;">这样的渴望显得残忍与粗暴。毕竟，他们缺乏时间与机遇。他们也没能“到欧洲去”、“到美国去”，去那些国家的中国青年学习的更多是技术而非写作。</p>
// <p style="white-space: normal;">对于沉浸于 20 年代美国情绪中的我来说，我很愿意把自己想象成迈克尔·考利。生于 60 年代的青年不喜欢技术与商业，认为它们毁灭了我们的心灵。但我更愿意将 20 年代美国作家的成功分给当时美国的技术与商业革命。正是福特的努力，正是留声机与广播这样的发明，让美国人生活得更富裕，资讯更发达，开始有时间与精力阅读了。像菲茨杰拉德、海明威的作品都是先成为时尚，然后才成为经典的。</p>
// <p style="white-space: normal;">那么今天的我呢？一个生于 1976 年的青年，就像我最初写到的，在我进入大学这一年，以互联网为主的新技术革命正在席卷全球，从 1995 年到今天，技术革命对普通中国人的影响比起从前的政治更为巨大。当我在鄙薄了 90 年代中期平庸的校园之后，必须承认，那些在新技术影响下于 1998 年后入学的青年的确有了更多的选择机会。他们也并非像我过去认为的那样没有头脑、没有感情，新资讯革命让他们的知识层次更丰富，也更加独立、强调个人主义。而新技术革命所带来的全球化现象，则让他们真的与巴黎、纽约生活在一起。他们或许快乐多于忧伤，但到目前为止我还不能说不忧伤就是缺乏人文关怀。</p>
// <p style="white-space: normal;">好了，我已经在青春的时空中穿梭了一个世纪，并且自恋地让自己回到了 1997 年那个脸上长满粉刺的青年时代。我不断地提及历史，又不断地否认过去。我知道我无法看清楚未来，但是我越来越清晰地听到召唤的声音。这声音令我的情绪再次激昂，提醒我不管身在何处，都必须不懈地学习。尽管我不知道自己是否会像 1890 年代那批美国青年那样最终被淹没，还是像菲茨杰拉德一样留下痕迹，但有一点很清楚，我必须不断吸收世界上最杰出的思想文化，因为它们比自我回忆更有建设性，即使是过渡的一代，我也希望这种过渡更加坚实。</p>
// <p style="white-space: normal;">
//     <img src="http://img.owspace.com/Public/uploads/Editor/2019-12-05/1575550813391107.jpeg" width="1080" height="129" />
// </p>
// <p>
//     <br/>
// </p>
//   ''';
//   var document;
//   try {
//     document = parse('<root>$xmlStr</root>');
//     // var textual = document.descendants
//     //     .where((node) => node is xml.XmlText && node.text.trim().isNotEmpty)
//     //     .join('\n');
//   } catch (e) {
//     print(e.toString());
//   }
//   if (document == null) {
//     return;
//   }
//   Map<String, int> tags = {};
//   document.descendants.forEach((XmlNode node) {
//     if (node is XmlElement) {
//       print('[${node.nodeType}] xml element');
//       String tagName = node.name.toString();
//       if (tags.containsKey(tagName)) {
//         tags[tagName] += 1;
//       } else {
//         tags[tagName] = 1;
//       }
//     } else {
//       print('[${node.nodeType}] not xml element, skipped');
//     }
//   });
//   print(tags);

//   //print(textual);
// }

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
