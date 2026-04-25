// Last Updated: 2026-04-25
// 最后更新: 2026-04-25
//
// Module: Guidance concept dialogue data - Myo chat scripts for 12 chapters
// 模块: 投资者教育概念对话数据 - 12 章 Myo 聊天脚本
//
// Dependencies: guidance_models
// 依赖: guidance_models
//
// Author: Harry Chen / AI
// Email: 11911421@mail.sustech.edu.cn

import '../domain/guidance_models.dart';

const Map<int, GuidanceConceptDialogue> guidanceConceptDialogues =
    <int, GuidanceConceptDialogue>{
      1: GuidanceConceptDialogue(
        lessonId: 'CH01',
        chapterNumber: 1,
        turns: <GuidanceConceptTurn>[
          GuidanceConceptTurn(
            id: 'CH01_C01',
            myoText: '先从最容易误会的地方开始：你在二级市场买股票，钱通常不是直接给上市公司，而是给卖出股票的投资者。',
            highlightedTerms: <String>{'二级市场', '股票'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '所以它更像二手交易？',
                myoResponse: '对，二级市场最像“已经发行出来的证券再转手”。交易所负责规则和撮合，公司通常不直接收这笔钱。',
                highlightedTerms: <String>{'二级市场', '证券', '交易所'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '那公司一点关系都没有吗？',
                myoResponse:
                    '有关系，但不是每次二级市场买卖都融资。股价和流动性会影响公司形象与融资条件，但成交资金主要给卖家。',
                highlightedTerms: <String>{'二级市场', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我以前一直以为钱给公司。',
                myoResponse: '这个误会很常见。把它拆开后，你会更容易理解一级市场和二级市场的区别。',
                highlightedTerms: <String>{'一级市场', '二级市场'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH01_C02',
            myoText: '如果一级市场像新店第一次卖会员卡，二级市场就像会员卡后来在别人之间转让。你觉得关键差别是什么？',
            highlightedTerms: <String>{'一级市场', '二级市场'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '第一次卖出时，钱才主要进发行人那里。',
                myoResponse: '抓得很准。一级市场的核心是发行融资，二级市场的核心是投资者之间转让。',
                highlightedTerms: <String>{'一级市场', '二级市场'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '二级市场是不是就不重要？',
                myoResponse: '不，它很重要。没有二级市场，很多人会担心买了以后卖不出去，一级市场也会更难吸引资金。',
                highlightedTerms: <String>{'二级市场', '一级市场'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '是不是只有股票有二级市场？',
                myoResponse: '不是。股票、债券、场内基金等已经发行的证券，都可能在二级市场交易。',
                highlightedTerms: <String>{'股票', '债券', '场内基金', '证券', '二级市场'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH01_C03',
            myoText: '再看一个词：流动性。它不是“稳赚”，而是你想买或想卖时，能不能比较顺利成交。',
            highlightedTerms: <String>{'流动性'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '流动性好就是更容易退出。',
                myoResponse: '对。它像门能不能打开，不代表门里一定有宝贝，也不代表不会亏。',
                highlightedTerms: <String>{'流动性'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '流动性好是不是收益更高？',
                myoResponse: '不等于。流动性解决的是“能不能交易”，收益还要看资产质量、价格和风险。',
                highlightedTerms: <String>{'流动性'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '新手为什么要关心这个？',
                myoResponse: '因为新手最怕想用钱时卖不出去。先知道退出通道，比急着猜涨跌更重要。',
                highlightedTerms: <String>{'流动性'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH01_C04',
            myoText: '最后把角色摆清楚：买方、卖方、交易所、上市公司都在这个故事里，但收钱和定规则的角色不一样。',
            highlightedTerms: <String>{'交易所'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '买方付钱，卖方交出股票。',
                myoResponse: '对，这就是二级市场成交的主线。交易所像有规则的集市，不是这笔成交的主要收款方。',
                highlightedTerms: <String>{'二级市场', '交易所'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '公司负责每天给我报价吗？',
                myoResponse: '不是。市场报价来自买卖双方的委托和成交，交易所组织交易，上市公司披露信息。',
                highlightedTerms: <String>{'交易所'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我能总结为“投资者之间转让”吗？',
                myoResponse: '可以。这一章你只要先记住：二级市场是已发行证券在投资者之间转让，流动性决定退出是否顺畅。',
                highlightedTerms: <String>{'二级市场', '证券', '流动性'},
              ),
            ],
          ),
        ],
      ),
      2: GuidanceConceptDialogue(
        lessonId: 'CH02',
        chapterNumber: 2,
        turns: <GuidanceConceptTurn>[
          GuidanceConceptTurn(
            id: 'CH02_C01',
            myoText: '股票代码像门牌号。600、300、688、8/4 开头，先帮我们判断大概在哪个交易所和板块。',
            highlightedTerms: <String>{'股票', '交易所', '板块'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '代码是第一条线索。',
                myoResponse: '对，但只是线索。看到代码后，还要查交易所、板块规则和风险标识。',
                highlightedTerms: <String>{'交易所', '板块'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '前缀能直接判断能不能买吗？',
                myoResponse: '不能。前缀告诉你住在哪个街区，不等于适合你的风险承受力。',
                highlightedTerms: <String>{'板块'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我需要背全部规则吗？',
                myoResponse: '不需要先背全，先建立“陌生代码先查门牌”的习惯。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH02_C02',
            myoText: '不同板块不是高低贵贱，而是规则、波动和门槛不同。',
            highlightedTerms: <String>{'板块'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '成长板块通常波动更明显。',
                myoResponse: '对，成长故事可能更强，价格波动也可能更明显。',
                highlightedTerms: <String>{'板块'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '主板就完全没风险吗？',
                myoResponse: '不是。主板只是规则不同，不代表不会下跌。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '新板块是不是更高级？',
                myoResponse: '不是越新越高级。我们只看规则、流动性和风险是否匹配自己。',
                highlightedTerms: <String>{'流动性'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH02_C03',
            myoText: '新手看到陌生代码，第一步不是买一点试试，而是确认它的交易所、板块、风险提示和交易规则。',
            highlightedTerms: <String>{'交易所', '板块'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先查清楚再行动。',
                myoResponse: '对。先看门牌，再决定要不要进门。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '评论区热度可以参考吗？',
                myoResponse: '可以当噪音观察，但不能替代规则识别和风险判断。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '涨很多是不是说明安全？',
                myoResponse: '不说明。涨幅只能说明过去价格变化，不能说明风险消失。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH02_C04',
            myoText: '这一章的概念核心：代码先帮你定位，板块规则决定你要查什么，不要把门牌号当投资理由。',
            highlightedTerms: <String>{'板块'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '门牌号不是推荐信。',
                myoResponse: '很好，这句话很适合写进你的新手规则。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我会先查规则和风险标识。',
                myoResponse: '对，这比追热度更像投资者。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我想继续看交易规则。',
                myoResponse: '下一章就会把交易时间、委托和涨跌幅这些安全带装上。',
                highlightedTerms: <String>{'交易时间', '涨跌幅'},
              ),
            ],
          ),
        ],
      ),
      3: GuidanceConceptDialogue(
        lessonId: 'CH03',
        chapterNumber: 3,
        turns: <GuidanceConceptTurn>[
          GuidanceConceptTurn(
            id: 'CH03_C01',
            myoText: '交易账户不是游戏按钮区。先认识交易时间、委托方式和买卖限制，才能少点误操作。',
            highlightedTerms: <String>{'交易时间'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先知道什么时候能交易。',
                myoResponse: '对，市场不是 24 小时都按同一套规则成交。',
                highlightedTerms: <String>{'交易时间'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '按钮多就更自由吗？',
                myoResponse: '按钮多只说明功能多，不代表风险小。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我怕点错单。',
                myoResponse: '这正是先学规则的原因。规则是新手安全带。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH03_C02',
            myoText: '普通 A 股常见规则是今天买入后，通常下一交易日才能卖出。',
            highlightedTerms: <String>{'股票'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '不是所有东西都能当天卖。',
                myoResponse: '对，先记住这个刹车，能避免把短线冲动当灵活。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '那我买前要更慢一点。',
                myoResponse: '对。不能马上退出时，买入理由更要清楚。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '这个规则会有例外吗？',
                myoResponse: '会，不同资产和市场规则不同，所以每次接触新品种都要先查。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH03_C03',
            myoText: '市价委托追求尽快成交，但成交价格可能和你想的不一样。',
            highlightedTerms: <String>{'市价委托'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '快不等于价格最舒服。',
                myoResponse: '对。市价委托像“现在能成交就先成交”，要小心滑点。',
                highlightedTerms: <String>{'市价委托'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '是不是一定成交？',
                myoResponse: '也不是绝对。它提高成交优先级，但仍受市场和规则影响。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '新手可以少用它。',
                myoResponse: '这是稳妥想法。先理解限价和市价的差异，再决定怎么下单。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH03_C04',
            myoText: '涨跌幅像价格护栏，但护栏不等于不会亏，也不等于明天不会继续波动。',
            highlightedTerms: <String>{'涨跌幅'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '护栏不是保险箱。',
                myoResponse: '对。涨跌幅限制只是单日波动边界，不是收益保证。',
                highlightedTerms: <String>{'涨跌幅'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '不同板块限制也不同吧？',
                myoResponse: '对，所以代码和板块识别会继续派上用场。',
                highlightedTerms: <String>{'板块'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '这一章就是先装刹车。',
                myoResponse: '很准确。交易前先看时间、委托、涨跌幅和能否退出。',
                highlightedTerms: <String>{'交易时间', '涨跌幅'},
              ),
            ],
          ),
        ],
      ),
      4: GuidanceConceptDialogue(
        lessonId: 'CH04',
        chapterNumber: 4,
        turns: <GuidanceConceptTurn>[
          GuidanceConceptTurn(
            id: 'CH04_C01',
            myoText: 'K 线是记录本，不是水晶球。它记录开盘、最高、最低、收盘这些价格变化。',
            highlightedTerms: <String>{'K 线'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先把它当记录。',
                myoResponse: '对，记录可以帮助观察，但不能单独替你做决定。',
                highlightedTerms: <String>{'K 线'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '图形不能预测未来？',
                myoResponse: '不能保证。它最多提供线索，需要和基本面、估值、风险一起看。',
                highlightedTerms: <String>{'估值'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '红绿颜色会不会误导情绪？',
                myoResponse: '会。颜色很容易刺激情绪，所以要回到“它记录了什么”。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH04_C02',
            myoText: '成交量代表一段时间里交易有多活跃，但活跃不等于方向确定。',
            highlightedTerms: <String>{'成交量'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '人多不代表东西一定好。',
                myoResponse: '对，店里热闹只说明热闹，不说明商品一定值得买。',
                highlightedTerms: <String>{'成交量'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '放量一定上涨吗？',
                myoResponse: '不一定。要结合价格位置、消息和更长周期。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '成交量更像注意信号。',
                myoResponse: '这个理解更稳。它提醒你观察，不直接给买卖答案。',
                highlightedTerms: <String>{'成交量'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH04_C03',
            myoText: '周期越短，噪音通常越大；周期越长，更适合看轮廓。',
            highlightedTerms: <String>{'K 线'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '分时像放大镜。',
                myoResponse: '对，能看细节，也会看到很多噪音。',
                highlightedTerms: <String>{'K 线'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '周线更像地图。',
                myoResponse: '对，它牺牲细节，换来更清楚的方向轮廓。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我不该只盯一分钟。',
                myoResponse: '新手少被短周期牵着跑，会少很多冲动。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH04_C04',
            myoText: '这一章的安全句：行情图能帮你观察价格和活跃度，但不能替代研究和风险控制。',
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '我会把图当证据之一。',
                myoResponse: '对，是证据之一，不是全部证据。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '单一形态不重注。',
                myoResponse: '稳。单一形态最容易让新手过度自信。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一步需要学估值。',
                myoResponse: '正好，下一章我们就问“价格配不配这家公司”。',
                highlightedTerms: <String>{'估值'},
              ),
            ],
          ),
        ],
      ),
      5: GuidanceConceptDialogue(
        lessonId: 'CH05',
        chapterNumber: 5,
        turns: <GuidanceConceptTurn>[
          GuidanceConceptTurn(
            id: 'CH05_C01',
            myoText: '估值不是看股价高低，而是问：这个价格配不配它的利润、资产、分红和成长。',
            highlightedTerms: <String>{'估值', '分红'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '股价高不一定贵。',
                myoResponse: '对。绝对价格只是门口数字，估值要看背后质量。',
                highlightedTerms: <String>{'估值'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '低价也不一定便宜。',
                myoResponse: '对。低价可能是机会，也可能是基本面变差的信号。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '要把价格和东西一起看。',
                myoResponse: '这就是估值的起点。',
                highlightedTerms: <String>{'估值'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH05_C02',
            myoText: '市盈率 PE 可以粗略理解为：市场愿意为公司每 1 元利润付多少钱。',
            highlightedTerms: <String>{'市盈率'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '它围绕利润定价。',
                myoResponse: '对。PE 先问利润，但利润质量和周期也要继续看。',
                highlightedTerms: <String>{'市盈率'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: 'PE 越低越好吗？',
                myoResponse: '不一定。低 PE 可能是低估，也可能是市场担心利润下滑。',
                highlightedTerms: <String>{'市盈率'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '亏损公司 PE 怎么看？',
                myoResponse: '亏损时 PE 可能失灵，就要换其他角度看资产、现金流和成长。',
                highlightedTerms: <String>{'现金流'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH05_C03',
            myoText: '市净率 PB 看价格和净资产的关系，股息率看现金分红相对价格的大致比例。',
            highlightedTerms: <String>{'市净率', '股息率', '分红'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '不同指标回答不同问题。',
                myoResponse: '对。别把指标缩写背成一团，先问它在回答什么。',
                highlightedTerms: <String>{'市净率', '股息率'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '一个指标不能定生死。',
                myoResponse: '对，估值要组合看，尤其要结合行业和公司质量。',
                highlightedTerms: <String>{'估值'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '分红也不是永远固定。',
                myoResponse: '没错。股息率看起来高，也要看分红能否持续。',
                highlightedTerms: <String>{'股息率', '分红'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH05_C04',
            myoText: '看到“便宜”两个字时，Myo 想让你多问一句：便宜的原因是什么？',
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '是被低估，还是变差了？',
                myoResponse: '这是估值章节最关键的问题。低估和价值陷阱只差一次验证。',
                highlightedTerms: <String>{'估值'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '不能只看排行榜。',
                myoResponse: '对。低 PE 榜单不是购物清单。',
                highlightedTerms: <String>{'市盈率'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一步要认识公司。',
                myoResponse: '正好。估值离不开公司质量，下一章看公司简历。',
                highlightedTerms: <String>{'估值'},
              ),
            ],
          ),
        ],
      ),
      6: GuidanceConceptDialogue(
        lessonId: 'CH06',
        chapterNumber: 6,
        turns: <GuidanceConceptTurn>[
          GuidanceConceptTurn(
            id: 'CH06_C01',
            myoText: '认识一家上市公司，先问它做什么、怎么赚钱、钱有没有真的收回来。',
            highlightedTerms: <String>{'现金流'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先看业务，再看热搜。',
                myoResponse: '对。热搜能给线索，但不能替代理解商业模式。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '利润和现金流都要看。',
                myoResponse: '对，利润说明账面结果，现金流帮助确认钱有没有回来。',
                highlightedTerms: <String>{'现金流'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我会先问它卖什么。',
                myoResponse: '很好。业务听不懂时，不急着买。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH06_C02',
            myoText: '负债不是原罪，但负债过高会让公司在环境变差时更脆弱。',
            highlightedTerms: <String>{'负债'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '像家庭贷款压力。',
                myoResponse: '对。收入稳定时能承受，压力太大就会危险。',
                highlightedTerms: <String>{'负债'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '负债越低越好吗？',
                myoResponse: '也不绝对。关键是行业特点、期限结构和偿债能力。',
                highlightedTerms: <String>{'负债'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我要看资产负债率。',
                myoResponse: '可以作为入口，但别只看一个数字。',
                highlightedTerms: <String>{'负债'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH06_C03',
            myoText: '公司研究不是为了找到完美公司，而是为了知道自己承担了什么风险。',
            highlightedTerms: <String>{'公司风险'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '没有公司是零风险。',
                myoResponse: '对。再好的公司也会受行业、管理和市场影响。',
                highlightedTerms: <String>{'公司风险'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '看懂风险比听故事重要。',
                myoResponse: '很稳。故事负责吸引你，风险负责考验你。',
                highlightedTerms: <String>{'公司风险'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我要写下买入理由。',
                myoResponse: '这是好习惯。未来复盘时，你会知道原假设有没有变化。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH06_C04',
            myoText: '这一章的顺序：业务、利润、现金流、负债、风险提示。看完这些，再谈估值。',
            highlightedTerms: <String>{'现金流', '负债', '估值'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先体检，再报价。',
                myoResponse: '对。公司质量没看清，估值数字容易误导。',
                highlightedTerms: <String>{'估值'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我不会只看概念题材。',
                myoResponse: '很好。题材可能会热，现金流和负债更能暴露基本情况。',
                highlightedTerms: <String>{'现金流', '负债'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一章该学风险了。',
                myoResponse: '是的。看完公司，下一步就是把风险来源分门别类。',
              ),
            ],
          ),
        ],
      ),
      7: GuidanceConceptDialogue(
        lessonId: 'CH07',
        chapterNumber: 7,
        turns: <GuidanceConceptTurn>[
          GuidanceConceptTurn(
            id: 'CH07_C01',
            myoText: '风险不是只有“会不会跌”。它可能来自市场、公司，也可能来自自己的情绪和仓位。',
            highlightedTerms: <String>{'市场风险', '公司风险', '仓位'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先分清风险来源。',
                myoResponse: '对。风险来源不同，处理工具也不同。',
                highlightedTerms: <String>{'市场风险', '公司风险'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我自己也会成为风险？',
                myoResponse: '会。冲动、重仓和借钱都会把小波动放大。',
                highlightedTerms: <String>{'仓位'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下跌只是结果之一。',
                myoResponse: '对，我们要看造成结果的原因。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH07_C02',
            myoText: '市场风险像大雨，很多资产会一起受影响；公司风险像某一段路塌了，集中影响单家公司。',
            highlightedTerms: <String>{'市场风险', '公司风险'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '分散能减少单点风险。',
                myoResponse: '对，分散能降低公司单点问题，但不能消灭整个市场的大雨。',
                highlightedTerms: <String>{'分散', '公司风险', '市场风险'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '市场风险没法完全躲掉。',
                myoResponse: '对，可以用仓位、期限和资产配置管理，但不能假装它不存在。',
                highlightedTerms: <String>{'市场风险', '仓位', '资产配置'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '公司风险要靠研究。',
                myoResponse: '对。业务、财务和治理都能帮你识别公司风险。',
                highlightedTerms: <String>{'公司风险'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH07_C03',
            myoText: '仓位决定一次波动会伤到你多少。新手最危险的动作之一，是借钱加仓。',
            highlightedTerms: <String>{'仓位'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '仓位像背包重量。',
                myoResponse: '对。背包太重，每一步波动都会更累。',
                highlightedTerms: <String>{'仓位'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '借钱会改变难度。',
                myoResponse: '非常关键。杠杆会放大亏损和情绪压力，不适合新手学习。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '小额学习更稳。',
                myoResponse: '对。学习期先保留犯错空间。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH07_C04',
            myoText: '风险管理不是消灭波动，而是让波动不会摧毁你的生活和计划。',
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '现金缓冲也算风险管理。',
                myoResponse: '对。现金缓冲能减少被迫卖出的压力。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '分散、仓位、期限一起用。',
                myoResponse: '很好。单个工具不万能，组合使用更稳。',
                highlightedTerms: <String>{'分散', '仓位'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一章学一篮子资产。',
                myoResponse: '正好。指数基金就是理解分散的好入口。',
                highlightedTerms: <String>{'指数基金', '分散'},
              ),
            ],
          ),
        ],
      ),
      8: GuidanceConceptDialogue(
        lessonId: 'CH08',
        chapterNumber: 8,
        turns: <GuidanceConceptTurn>[
          GuidanceConceptTurn(
            id: 'CH08_C01',
            myoText: '指数基金像一只透明篮子：它按规则装进一组资产，而不是押单家公司。',
            highlightedTerms: <String>{'指数基金'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '买规则，不是买神秘故事。',
                myoResponse: '对。指数产品的友好点之一就是规则相对透明。',
                highlightedTerms: <String>{'指数基金'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '一篮子也会跌吗？',
                myoResponse: '会。分散降低单点风险，不代表保本。',
                highlightedTerms: <String>{'分散'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '它比单只股票更分散。',
                myoResponse: '通常是这样，尤其是宽基指数覆盖更多代表性资产。',
                highlightedTerms: <String>{'股票', '宽基'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH08_C02',
            myoText: '宽基更像市场整体篮子，行业和主题篮子更窄，也更需要你知道押的是什么。',
            highlightedTerms: <String>{'宽基'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '越窄越集中。',
                myoResponse: '对。集中可能带来弹性，也会放大特定方向的风险。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '宽基不等于无风险。',
                myoResponse: '对，它只是更分散，仍会随市场波动。',
                highlightedTerms: <String>{'宽基', '分散'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '主题名字不能替代持仓。',
                myoResponse: '很稳。先看篮子里装了谁，再看名字。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH08_C03',
            myoText: '选基金时，新手先看费率、规模、跟踪稳定性和流动性。',
            highlightedTerms: <String>{'流动性'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '费用会长期影响结果。',
                myoResponse: '对。低费率不是唯一条件，但长期很重要。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '规模太小要小心。',
                myoResponse: '对，规模和流动性会影响交易体验和持续性。',
                highlightedTerms: <String>{'流动性'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '跟踪偏离也要看。',
                myoResponse: '没错。指数基金要看它有没有认真跟住目标指数。',
                highlightedTerms: <String>{'指数基金'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH08_C04',
            myoText: '指数基金适合做学习入口，但不是“闭眼买”。规则透明，也要匹配期限和风险承受力。',
            highlightedTerms: <String>{'指数基金'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '友好不等于无风险。',
                myoResponse: '对，这句可以贯穿所有投资工具。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '先选宽基，再理解行业主题。',
                myoResponse: '对新手来说，这是更稳的学习顺序。',
                highlightedTerms: <String>{'宽基'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '还要留现金。',
                myoResponse: '是的。下一章我们就讲有些钱的任务不是冲锋，而是站岗。',
              ),
            ],
          ),
        ],
      ),
      9: GuidanceConceptDialogue(
        lessonId: 'CH09',
        chapterNumber: 9,
        turns: <GuidanceConceptTurn>[
          GuidanceConceptTurn(
            id: 'CH09_C01',
            myoText: '有些钱的任务是站岗。应急金优先安全性和流动性，不负责追高收益。',
            highlightedTerms: <String>{'应急金', '流动性'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '应急金要随时能用。',
                myoResponse: '对。它像备用钥匙，关键时刻要能打开门。',
                highlightedTerms: <String>{'应急金'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '它不是用来冲收益。',
                myoResponse: '对。应急金的第一职责是救场，不是冒险。',
                highlightedTerms: <String>{'应急金'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '流动性比收益优先。',
                myoResponse: '在应急金场景里，是的。用途决定优先级。',
                highlightedTerms: <String>{'流动性', '应急金'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH09_C02',
            myoText: '固收听起来稳，但债券和债基也会受利率、信用、期限影响。',
            highlightedTerms: <String>{'固收', '债券'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '固收也会波动。',
                myoResponse: '对。它通常波动更低，但不是静止。',
                highlightedTerms: <String>{'固收'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '债券像借条。',
                myoResponse: '对，但也要看借款方信用和利率环境。',
                highlightedTerms: <String>{'债券'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '名字稳不代表保本。',
                myoResponse: '很关键。产品名字不能替代底层资产分析。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH09_C03',
            myoText: '资金期限越短，越不能承受大波动。明年要交学费的钱，不适合坐过山车。',
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '短期钱先保用途。',
                myoResponse: '对。短期刚需资金的目标是按时可用。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '长期闲钱才谈波动承受。',
                myoResponse: '对，能等更久，才有空间承受权益波动。',
                highlightedTerms: <String>{'权益'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '按期限分层。',
                myoResponse: '很好。随时用、1 年内用、5 年以上不用，应该放在不同风险层。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH09_C04',
            myoText: '现金管理和固收像组合里的稳定器，但稳定器也有说明书。',
            highlightedTerms: <String>{'现金管理', '固收'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '我要看底层资产。',
                myoResponse: '对。货币工具、短债、债基的波动和风险来源不同。',
                highlightedTerms: <String>{'债基'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '先保护生活安全垫。',
                myoResponse: '这就是稳健投资的地基。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一章处理情绪。',
                myoResponse: '是的。工具摆好后，还要给情绪装暂停键。',
              ),
            ],
          ),
        ],
      ),
      10: GuidanceConceptDialogue(
        lessonId: 'CH10',
        chapterNumber: 10,
        turns: <GuidanceConceptTurn>[
          GuidanceConceptTurn(
            id: 'CH10_C01',
            myoText: '情绪不是敌人，但从众和 FOMO 会把“别人都在做”伪装成投资理由。',
            highlightedTerms: <String>{'从众'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '热闹不是理由。',
                myoResponse: '对。热闹可以提醒你观察，但不能替你完成判断。',
                highlightedTerms: <String>{'从众'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我会怕错过。',
                myoResponse: '很正常。识别 FOMO 的第一步就是承认这种压力存在。',
                highlightedTerms: <String>{'从众'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '大家赚钱会让我冲动。',
                myoResponse: '这就是从众最常见的入口，所以要提前写规则。',
                highlightedTerms: <String>{'从众'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH10_C02',
            myoText: '损失厌恶会让人不愿承认亏损，甚至为了不难受而拖延决策。',
            highlightedTerms: <String>{'损失厌恶'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '亏损会让我想逃避。',
                myoResponse: '这很常见。规则的作用就是在难受时给你扶手。',
                highlightedTerms: <String>{'损失厌恶'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '不看账户也不能解决问题。',
                myoResponse: '对。不看只会延迟处理，不会改变事实。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '要回到买入理由。',
                myoResponse: '对。检查原假设是否变化，比盯着亏损数字更有用。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH10_C03',
            myoText: '冷静期、仓位上限和投资日志，是给情绪准备的三个工具。',
            highlightedTerms: <String>{'仓位'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '冷静期延迟冲动。',
                myoResponse: '对，先慢下来，很多错误会自己浮出来。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '仓位上限限制伤害。',
                myoResponse: '对。就算判断错了，也不让单次错误击穿生活。',
                highlightedTerms: <String>{'仓位'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '投资日志帮助复盘。',
                myoResponse: '对，它让你看见自己当时为什么行动。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH10_C04',
            myoText: '这一章不是让你没有情绪，而是让情绪最吵的时候，动作更慢一点。',
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先暂停，再决策。',
                myoResponse: '很好。暂停键比预测更实用。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '规则写在冲动之前。',
                myoResponse: '对。等冲动来了再写规则，通常太晚。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一章用规则定投。',
                myoResponse: '正好。定投就是把“猜时点”换成“按规则执行”。',
                highlightedTerms: <String>{'定投'},
              ),
            ],
          ),
        ],
      ),
      11: GuidanceConceptDialogue(
        lessonId: 'CH11',
        chapterNumber: 11,
        turns: <GuidanceConceptTurn>[
          GuidanceConceptTurn(
            id: 'CH11_C01',
            myoText: '定投不是保证盈利的魔法，而是把一次性猜时点改成按规则分批投入。',
            highlightedTerms: <String>{'定投'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '它降低择时压力。',
                myoResponse: '对。它不保证结果，但减少“必须一次猜对”的压力。',
                highlightedTerms: <String>{'定投'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '定投也会亏吗？',
                myoResponse: '会。资产长期不修复，定投也不能变魔法。',
                highlightedTerms: <String>{'定投'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '规则比情绪更稳定。',
                myoResponse: '这就是定投的核心价值。',
                highlightedTerms: <String>{'定投'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH11_C02',
            myoText: '微笑曲线成立有前提：资产长期有恢复和增长机会，你也有能力持续执行。',
            highlightedTerms: <String>{'定投'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '不是所有下跌都会微笑。',
                myoResponse: '对。没有修复和增长，曲线不会自己变好。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '现金流要撑得住。',
                myoResponse: '对。定投金额必须来自可承受的长期闲钱。',
                highlightedTerms: <String>{'现金流', '定投'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '执行能力也是条件。',
                myoResponse: '没错。漂亮计划不如能坚持的小计划。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH11_C03',
            myoText: '一个可执行定投计划，至少要写清楚金额、频率、资产、暂停条件和复盘时间。',
            highlightedTerms: <String>{'定投'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '金额不能挤压生活。',
                myoResponse: '对。定投不能抢应急金的位置。',
                highlightedTerms: <String>{'定投', '应急金'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '频率固定更容易执行。',
                myoResponse: '对，固定频率能减少每次重新纠结。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '还要设置复盘。',
                myoResponse: '对。长期执行不等于永远不检查。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH11_C04',
            myoText: '定投真正训练的是长期规则感：少问“明天涨吗”，多问“这个计划我能坚持吗”。',
            highlightedTerms: <String>{'定投'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '能坚持比金额大更重要。',
                myoResponse: '对。新手计划首先要可承受。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '先留应急金再定投。',
                myoResponse: '稳。安全垫在前，长期计划在后。',
                highlightedTerms: <String>{'应急金', '定投'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '最后要搭组合。',
                myoResponse: '是的。下一章把现金、固收、权益放回各自岗位。',
                highlightedTerms: <String>{'固收', '权益'},
              ),
            ],
          ),
        ],
      ),
      12: GuidanceConceptDialogue(
        lessonId: 'CH12',
        chapterNumber: 12,
        turns: <GuidanceConceptTurn>[
          GuidanceConceptTurn(
            id: 'CH12_C01',
            myoText: '稳健组合不是猜哪只最强，而是让现金、固收、权益分别服务不同期限和用途。',
            highlightedTerms: <String>{'资产配置', '固收', '权益'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '现金管短期和流动性。',
                myoResponse: '对。随时要用的钱先保证能用。',
                highlightedTerms: <String>{'流动性'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '固收做稳定器。',
                myoResponse: '对，但稳定器也有波动和说明书。',
                highlightedTerms: <String>{'固收'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '权益承担长期成长。',
                myoResponse: '对，权益通常更波动，所以更需要长期资金和仓位约束。',
                highlightedTerms: <String>{'权益', '仓位'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH12_C02',
            myoText: '资产配置先问两个问题：这笔钱什么时候要用？如果下跌，我能不能等？',
            highlightedTerms: <String>{'资产配置'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '期限决定风险承受。',
                myoResponse: '对。短期钱不能赌长期修复。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '用途比热点重要。',
                myoResponse: '非常重要。钱有任务，资产才有岗位。',
                highlightedTerms: <String>{'资产配置'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '能等才有承受波动的空间。',
                myoResponse: '对。时间不是万能，但没有时间更难承受波动。',
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH12_C03',
            myoText: '组合不是只买一种，也不是把所有工具平均分。比例要来自用途、期限和承受力。',
            highlightedTerms: <String>{'资产配置'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '平均分不一定适合。',
                myoResponse: '对。比例不是数学平均，而是需求匹配。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '资产各司其职。',
                myoResponse: '很好。现金、固收、权益不是互相替代，而是分工。',
                highlightedTerms: <String>{'固收', '权益'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '仓位要有上限。',
                myoResponse: '对。仓位上限让组合不会因为单类资产失控。',
                highlightedTerms: <String>{'仓位'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH12_C04',
            myoText: '学完 12 章不是冲锋号，而是系统草稿：资金分层、风险上限、定投计划、复盘习惯。',
            highlightedTerms: <String>{'定投'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '我先写自己的资金分层。',
                myoResponse: '对，这比立刻交易更重要。',
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我会保留复盘入口。',
                myoResponse: '很好。系统需要更新，不是写完就锁死。',
              ),
              GuidanceConceptOption(
                id: 'C',
                text: 'Myo，我们从学习开始。',
                myoResponse: '这就是终章答案：先有系统，再谈行动。',
              ),
            ],
          ),
        ],
      ),
    };
