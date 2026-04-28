// Last Updated: 2026-04-28
// 最后更新: 2026-04-28
//
// Module: Guidance concept dialogue data - Myo guided concept paths for 12 chapters
// 模块: 投资者教育概念对话数据 - 12 章 Myo 引导式概念路径脚本
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
            myoText: 'Myo 先拆开一个常见误会：你在二级市场买股票，钱通常不是直接给上市公司，而是给愿意卖出股票的投资者。',
            highlightedTerms: <String>{'二级市场', '股票'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '所以更像二手转让？',
                myoResponse: '对，二级市场的核心是已发行证券在投资者之间转手；交易所负责规则和撮合，公司通常不直接收这笔成交资金。',
                highlightedTerms: <String>{'二级市场', '证券', '交易所'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '那上市公司没有直接收这笔钱？',
                myoResponse: '对，二级市场的核心是已发行证券在投资者之间转手；交易所负责规则和撮合，公司通常不直接收这笔成交资金。',
                highlightedTerms: <String>{'二级市场', '证券', '交易所'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我以前以为买股票就是给公司钱。',
                myoResponse: '对，二级市场的核心是已发行证券在投资者之间转手；交易所负责规则和撮合，公司通常不直接收这笔成交资金。',
                highlightedTerms: <String>{'二级市场', '证券', '交易所'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH01_C02',
            myoText: '把它想成一张演唱会票：第一次官方售票像一级市场，后来歌迷之间转让更像二级市场。',
            highlightedTerms: <String>{'一级市场', '二级市场'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '第一次卖出时，钱才主要进发行人那里。',
                myoResponse: '抓得很准。一级市场回答“谁发行融资”，二级市场回答“投资者之间怎么转让”，两个市场共同影响资金是否愿意进入。',
                highlightedTerms: <String>{'一级市场', '二级市场'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '二手转让也会影响大家愿不愿意买首发票吧？',
                myoResponse: '抓得很准。一级市场回答“谁发行融资”，二级市场回答“投资者之间怎么转让”，两个市场共同影响资金是否愿意进入。',
                highlightedTerms: <String>{'一级市场', '二级市场'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '所以两个市场不是互不相干。',
                myoResponse: '抓得很准。一级市场回答“谁发行融资”，二级市场回答“投资者之间怎么转让”，两个市场共同影响资金是否愿意进入。',
                highlightedTerms: <String>{'一级市场', '二级市场'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH01_C03',
            myoText: '再把角色摆上桌：买方想拿到股票，卖方想收回现金，交易所像有规则的集市，上市公司主要负责信息披露。',
            highlightedTerms: <String>{'股票', '交易所'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '买方付钱，卖方交出股票。',
                myoResponse: '对，二级市场成交的主线是买卖双方交换；报价来自委托和成交，上市公司不是每天替市场贴固定价格。',
                highlightedTerms: <String>{'二级市场', '股票', '交易所'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '报价是谁定的？',
                myoResponse: '对，二级市场成交的主线是买卖双方交换；报价来自委托和成交，上市公司不是每天替市场贴固定价格。',
                highlightedTerms: <String>{'二级市场', '股票', '交易所'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '公司在这里更像被观察的对象。',
                myoResponse: '对，二级市场成交的主线是买卖双方交换；报价来自委托和成交，上市公司不是每天替市场贴固定价格。',
                highlightedTerms: <String>{'二级市场', '股票', '交易所'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH01_C04',
            myoText: '现在放进一个小麻烦：你想买一只股票，但没人愿意卖；或者你急着卖，却没人愿意接。你会先问什么？',
            highlightedTerms: <String>{'股票'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '那我是不是就买不到或卖不掉？',
                myoResponse: '这正好引出“流动性”：想买或想卖时，能不能比较顺利成交；流动性差时，可能要等更久或接受更不舒服的价格。',
                highlightedTerms: <String>{'流动性'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '是不是要降价才能卖出去？',
                myoResponse: '这正好引出“流动性”：想买或想卖时，能不能比较顺利成交；流动性差时，可能要等更久或接受更不舒服的价格。',
                highlightedTerms: <String>{'流动性'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '交易的人越多会不会更顺？',
                myoResponse: '这正好引出“流动性”：想买或想卖时，能不能比较顺利成交；流动性差时，可能要等更久或接受更不舒服的价格。',
                highlightedTerms: <String>{'流动性'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH01_C05',
            myoText: '所以流动性不是“稳赚”，它更像门好不好打开：门好开，代表进出更顺，不代表屋里一定有宝贝。',
            highlightedTerms: <String>{'流动性'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '流动性好不等于收益高。',
                myoResponse: '对。流动性解决的是“能不能交易”和“交易成本高不高”，不是收益保证；新手尤其要关心退出通道。',
                highlightedTerms: <String>{'流动性'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '流动性差时退出更难。',
                myoResponse: '对。流动性解决的是“能不能交易”和“交易成本高不高”，不是收益保证；新手尤其要关心退出通道。',
                highlightedTerms: <String>{'流动性'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '那热门股票通常更容易成交？',
                myoResponse: '对。流动性解决的是“能不能交易”和“交易成本高不高”，不是收益保证；新手尤其要关心退出通道。',
                highlightedTerms: <String>{'流动性'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH01_C06',
            myoText: '价格也来自这个集市：买的人更急、卖的人更少，价格可能上移；卖的人更急、买的人更少，价格可能下移。',
            highlightedTerms: const <String>{},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '价格是在买卖拉扯中形成的。',
                myoResponse: '没错。二级市场不是单向标价，而是买卖双方持续出价和成交的结果；成交少时，价格更容易跳动。',
                highlightedTerms: <String>{'二级市场', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '没人交易时，价格参考也会变弱。',
                myoResponse: '没错。二级市场不是单向标价，而是买卖双方持续出价和成交的结果；成交少时，价格更容易跳动。',
                highlightedTerms: <String>{'二级市场', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '这和供需很像。',
                myoResponse: '没错。二级市场不是单向标价，而是买卖双方持续出价和成交的结果；成交少时，价格更容易跳动。',
                highlightedTerms: <String>{'二级市场', '流动性'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH01_C07',
            myoText: '收束一下：二级市场是已发行证券在投资者之间转让；看懂资金流向、成交角色和流动性，才算走进市场门口。',
            highlightedTerms: <String>{'二级市场', '证券', '流动性'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '我会先问钱流向谁。',
                myoResponse: '很好。本章锚点就是：钱主要流向卖家，交易由买卖双方撮合，流动性决定买卖是否顺畅。',
                highlightedTerms: <String>{'二级市场', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我会关心能不能顺利退出。',
                myoResponse: '很好。本章锚点就是：钱主要流向卖家，交易由买卖双方撮合，流动性决定买卖是否顺畅。',
                highlightedTerms: <String>{'二级市场', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我能总结为“投资者之间转让”。',
                myoResponse: '很好。本章锚点就是：钱主要流向卖家，交易由买卖双方撮合，流动性决定买卖是否顺畅。',
                highlightedTerms: <String>{'二级市场', '流动性'},
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
            myoText: 'Myo 先给你一张市场门牌图：600、000、300、688、8/4 开头，常常能提示它大概在哪个交易所和板块。',
            highlightedTerms: <String>{'交易所', '板块'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '代码像门牌号。',
                myoResponse: '对，代码是第一条线索，但不是投资理由；它提示你下一步该查交易所、板块和规则。',
                highlightedTerms: <String>{'交易所', '板块'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '看到 688 我先想到科创板。',
                myoResponse: '对，代码是第一条线索，但不是投资理由；它提示你下一步该查交易所、板块和规则。',
                highlightedTerms: <String>{'交易所', '板块'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '8 或 4 开头要想到北交所。',
                myoResponse: '对，代码是第一条线索，但不是投资理由；它提示你下一步该查交易所、板块和规则。',
                highlightedTerms: <String>{'交易所', '板块'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH02_C02',
            myoText: '如果你在行情软件看到陌生代码，Myo 不希望你先点买入，而是先问：它住在哪个市场街区？',
            highlightedTerms: <String>{'交易所'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先查交易所。',
                myoResponse: '稳。沪深北和不同板块的规则、门槛、波动气质不同，先看门牌，再谈机会。',
                highlightedTerms: <String>{'交易所', '板块'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '先查板块。',
                myoResponse: '稳。沪深北和不同板块的规则、门槛、波动气质不同，先看门牌，再谈机会。',
                highlightedTerms: <String>{'交易所', '板块'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '先别被名字带着跑。',
                myoResponse: '稳。沪深北和不同板块的规则、门槛、波动气质不同，先看门牌，再谈机会。',
                highlightedTerms: <String>{'交易所', '板块'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH02_C03',
            myoText: '不同板块不是高低贵贱，而是规则、波动、门槛和流动性不同。',
            highlightedTerms: <String>{'板块', '流动性'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '成长板块可能波动更大。',
                myoResponse: '对。板块只说明规则和风险特征不同，不代表越新越高级，也不代表主板就没有风险。',
                highlightedTerms: <String>{'板块', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '主板也不是零风险。',
                myoResponse: '对。板块只说明规则和风险特征不同，不代表越新越高级，也不代表主板就没有风险。',
                highlightedTerms: <String>{'板块', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '新板块不等于更高级。',
                myoResponse: '对。板块只说明规则和风险特征不同，不代表越新越高级，也不代表主板就没有风险。',
                highlightedTerms: <String>{'板块', '流动性'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH02_C04',
            myoText: 'Myo 现在故意问一句：如果一个代码今天涨很多，它的前缀能不能直接告诉你“能买”？',
            highlightedTerms: const <String>{},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '不能，前缀不是推荐信。',
                myoResponse: '不能。代码前缀只告诉你去哪查规则，不能替代适当性、风险承受力和投资研究。',
                highlightedTerms: <String>{'板块'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '还要看风险承受力。',
                myoResponse: '不能。代码前缀只告诉你去哪查规则，不能替代适当性、风险承受力和投资研究。',
                highlightedTerms: <String>{'板块'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '还要看我是否有权限和经验。',
                myoResponse: '不能。代码前缀只告诉你去哪查规则，不能替代适当性、风险承受力和投资研究。',
                highlightedTerms: <String>{'板块'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH02_C05',
            myoText: '有些市场街区还会有特殊门禁：比如适当性门槛、涨跌幅差异、交易方式差异。你会怎么问？',
            highlightedTerms: <String>{'涨跌幅'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '这个板块我有没有资格参与？',
                myoResponse: '很好。陌生板块要同时查权限、涨跌幅、交易方式和流动性，不要等下单时才发现规则不同。',
                highlightedTerms: <String>{'板块', '涨跌幅', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '涨跌幅是不是不一样？',
                myoResponse: '很好。陌生板块要同时查权限、涨跌幅、交易方式和流动性，不要等下单时才发现规则不同。',
                highlightedTerms: <String>{'板块', '涨跌幅', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '交易活跃度够不够？',
                myoResponse: '很好。陌生板块要同时查权限、涨跌幅、交易方式和流动性，不要等下单时才发现规则不同。',
                highlightedTerms: <String>{'板块', '涨跌幅', '流动性'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH02_C06',
            myoText: '风险标识也像路牌：ST、退市风险、异常波动公告，都在提醒你这条路可能更颠。',
            highlightedTerms: const <String>{},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '看到风险标识要停一下。',
                myoResponse: '对。风险标识和正式公告比评论区情绪更可靠，越热闹越要把风险提示读完。',
                highlightedTerms: const <String>{},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '热度不能覆盖风险提示。',
                myoResponse: '对。风险标识和正式公告比评论区情绪更可靠，越热闹越要把风险提示读完。',
                highlightedTerms: const <String>{},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我会把公告当正式信息。',
                myoResponse: '对。风险标识和正式公告比评论区情绪更可靠，越热闹越要把风险提示读完。',
                highlightedTerms: const <String>{},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH02_C07',
            myoText: '这一章的路径图可以落成一句行动清单：陌生代码先查交易所、板块、权限、涨跌幅、风险标识和流动性。',
            highlightedTerms: <String>{'交易所', '板块', '涨跌幅', '流动性'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '门牌号不是买入理由。',
                myoResponse: '很好。门牌号负责定位，规则负责约束，投资理由还要靠后续研究。',
                highlightedTerms: <String>{'交易所', '板块'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '先查规则，再看机会。',
                myoResponse: '很好。门牌号负责定位，规则负责约束，投资理由还要靠后续研究。',
                highlightedTerms: <String>{'交易所', '板块'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一章就该学具体交易规则。',
                myoResponse: '很好。门牌号负责定位，规则负责约束，投资理由还要靠后续研究。',
                highlightedTerms: <String>{'交易所', '板块'},
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
            myoText: '交易账户不是游戏按钮区。Myo 先让你看三样安全带：交易时间、买卖限制和委托方式。',
            highlightedTerms: <String>{'交易时间'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先知道什么时候能交易。',
                myoResponse: '对，交易前先装安全带；按钮多只是功能多，不代表风险小。',
                highlightedTerms: <String>{'交易时间'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '按钮多不等于更自由。',
                myoResponse: '对，交易前先装安全带；按钮多只是功能多，不代表风险小。',
                highlightedTerms: <String>{'交易时间'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我怕点错单。',
                myoResponse: '对，交易前先装安全带；按钮多只是功能多，不代表风险小。',
                highlightedTerms: <String>{'交易时间'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH03_C02',
            myoText: '如果你中午 12 点看到价格变化，想立刻下单成交，第一反应应该是什么？',
            highlightedTerms: <String>{'交易时间'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先确认是不是交易时段。',
                myoResponse: '对。市场不是全天候连续成交，什么时候报、什么时候撮合，都要按交易时间来。',
                highlightedTerms: <String>{'交易时间'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '交易日也有午间休市。',
                myoResponse: '对。市场不是全天候连续成交，什么时候报、什么时候撮合，都要按交易时间来。',
                highlightedTerms: <String>{'交易时间'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '时间窗口会影响订单处理。',
                myoResponse: '对。市场不是全天候连续成交，什么时候报、什么时候撮合，都要按交易时间来。',
                highlightedTerms: <String>{'交易时间'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH03_C03',
            myoText: '再看退出问题：普通 A 股常见规则是今天买入后，通常下一交易日才能卖出。',
            highlightedTerms: <String>{'股票'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '不是所有东西都能当天卖。',
                myoResponse: '对。这条刹车提醒你：不能马上退出时，买入理由更要清楚；不同资产还要单独查规则。',
                highlightedTerms: <String>{'股票'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '那我买前要更慢一点。',
                myoResponse: '对。这条刹车提醒你：不能马上退出时，买入理由更要清楚；不同资产还要单独查规则。',
                highlightedTerms: <String>{'股票'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '不同资产会有例外吗？',
                myoResponse: '对。这条刹车提醒你：不能马上退出时，买入理由更要清楚；不同资产还要单独查规则。',
                highlightedTerms: <String>{'股票'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH03_C04',
            myoText: 'Myo 把下单方式做成两扇门：限价委托像“我只接受这个价”，市价委托像“尽快成交优先”。',
            highlightedTerms: <String>{'市价委托'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '市价委托快，但价格可能不舒服。',
                myoResponse: '稳。市价委托强调速度但可能有滑点；限价保护价格但不保证马上成交。',
                highlightedTerms: <String>{'市价委托'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '限价更像先画价格边界。',
                myoResponse: '稳。市价委托强调速度但可能有滑点；限价保护价格但不保证马上成交。',
                highlightedTerms: <String>{'市价委托'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '新手不能只追求快。',
                myoResponse: '稳。市价委托强调速度但可能有滑点；限价保护价格但不保证马上成交。',
                highlightedTerms: <String>{'市价委托'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH03_C05',
            myoText: '涨跌幅像价格护栏：它限制单日波动范围，但护栏不等于保险箱。',
            highlightedTerms: <String>{'涨跌幅'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '护栏不是保本。',
                myoResponse: '对。涨跌幅只是单日价格边界，不是收益保证，也不能替你消灭后续波动。',
                highlightedTerms: <String>{'涨跌幅', '板块'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '不同板块护栏可能不同。',
                myoResponse: '对。涨跌幅只是单日价格边界，不是收益保证，也不能替你消灭后续波动。',
                highlightedTerms: <String>{'涨跌幅', '板块'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '涨停也不代表明天安全。',
                myoResponse: '对。涨跌幅只是单日价格边界，不是收益保证，也不能替你消灭后续波动。',
                highlightedTerms: <String>{'涨跌幅', '板块'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH03_C06',
            myoText: '下单前，Myo 希望你养成一次“刹车检查”：证券名称、方向、价格、数量、资金、规则。',
            highlightedTerms: <String>{'证券'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先确认买卖方向。',
                myoResponse: '很好。多一个确认动作，少很多误操作；看不懂的按钮，不用真金白银测试。',
                highlightedTerms: <String>{'证券'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '价格和数量要再看一遍。',
                myoResponse: '很好。多一个确认动作，少很多误操作；看不懂的按钮，不用真金白银测试。',
                highlightedTerms: <String>{'证券'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '规则不清就先不下单。',
                myoResponse: '很好。多一个确认动作，少很多误操作；看不懂的按钮，不用真金白银测试。',
                highlightedTerms: <String>{'证券'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH03_C07',
            myoText: '这一章的概念锚点：交易前先看时间、能否退出、委托方式、涨跌幅和下单检查。',
            highlightedTerms: <String>{'交易时间', '市价委托', '涨跌幅'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '我会先装刹车。',
                myoResponse: '对。新手交易先求不犯大错，再慢慢理解更多工具。',
                highlightedTerms: <String>{'交易时间', '市价委托', '涨跌幅'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我会少用不懂的委托。',
                myoResponse: '对。新手交易先求不犯大错，再慢慢理解更多工具。',
                highlightedTerms: <String>{'交易时间', '市价委托', '涨跌幅'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一章看行情图。',
                myoResponse: '对。新手交易先求不犯大错，再慢慢理解更多工具。',
                highlightedTerms: <String>{'交易时间', '市价委托', '涨跌幅'},
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
            myoText: 'K 线是记录本，不是水晶球。它先记录价格走过哪里，不负责保证未来去哪里。',
            highlightedTerms: <String>{'K 线'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先把它当记录。',
                myoResponse: '对。行情图可以帮助观察，但不能单独替你做决定。',
                highlightedTerms: <String>{'K 线'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '图形不能保证预测未来。',
                myoResponse: '对。行情图可以帮助观察，但不能单独替你做决定。',
                highlightedTerms: <String>{'K 线'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '颜色会影响情绪。',
                myoResponse: '对。行情图可以帮助观察，但不能单独替你做决定。',
                highlightedTerms: <String>{'K 线'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH04_C02',
            myoText: '一根 K 线通常记录开盘、最高、最低、收盘。Myo 问你：如果只看收盘，会漏掉什么？',
            highlightedTerms: <String>{'K 线'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '会漏掉盘中波动。',
                myoResponse: '没错。开高低收能帮你看当天拉扯过程，但过程线索仍不能单独下结论。',
                highlightedTerms: <String>{'K 线'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '会漏掉冲高回落。',
                myoResponse: '没错。开高低收能帮你看当天拉扯过程，但过程线索仍不能单独下结论。',
                highlightedTerms: <String>{'K 线'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '会漏掉买卖力量的变化。',
                myoResponse: '没错。开高低收能帮你看当天拉扯过程，但过程线索仍不能单独下结论。',
                highlightedTerms: <String>{'K 线'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH04_C03',
            myoText: '成交量代表一段时间里交易有多活跃，但活跃不等于方向确定。',
            highlightedTerms: <String>{'成交量'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '人多不代表东西一定好。',
                myoResponse: '对。成交量提醒你观察热度和分歧，不直接给买卖答案。',
                highlightedTerms: <String>{'成交量'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '放量不一定上涨。',
                myoResponse: '对。成交量提醒你观察热度和分歧，不直接给买卖答案。',
                highlightedTerms: <String>{'成交量'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '成交量更像注意信号。',
                myoResponse: '对。成交量提醒你观察热度和分歧，不直接给买卖答案。',
                highlightedTerms: <String>{'成交量'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH04_C04',
            myoText: '周期像镜头：分时是放大镜，日线像日记，周线更像地图。镜头越近，噪音通常越多。',
            highlightedTerms: <String>{'K 线'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '分时细节多，也更吵。',
                myoResponse: '稳。不同周期回答不同问题，新手少被短周期噪音牵着跑。',
                highlightedTerms: <String>{'K 线'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '周线牺牲细节，看轮廓。',
                myoResponse: '稳。不同周期回答不同问题，新手少被短周期噪音牵着跑。',
                highlightedTerms: <String>{'K 线'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我不该只盯一分钟。',
                myoResponse: '稳。不同周期回答不同问题，新手少被短周期噪音牵着跑。',
                highlightedTerms: <String>{'K 线'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH04_C05',
            myoText: '如果一根 K 线很好看，但公司基本面变差、估值很贵、仓位也很重，你会问什么？',
            highlightedTerms: <String>{'K 线', '估值', '仓位'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '单一形态不能重注。',
                myoResponse: '对。图形只能做证据之一，不能替代公司质量、估值和仓位规则。',
                highlightedTerms: <String>{'K 线', '估值', '仓位'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '还要看公司和估值。',
                myoResponse: '对。图形只能做证据之一，不能替代公司质量、估值和仓位规则。',
                highlightedTerms: <String>{'K 线', '估值', '仓位'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '仓位不能被图形冲昏。',
                myoResponse: '对。图形只能做证据之一，不能替代公司质量、估值和仓位规则。',
                highlightedTerms: <String>{'K 线', '估值', '仓位'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH04_C06',
            myoText: '行情图最容易诱发“我好像看懂了”的感觉。Myo 希望你把它变成提问器，而不是命令器。',
            highlightedTerms: const <String>{},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '它应该帮我提出问题。',
                myoResponse: '很好。让图表帮你提出“为什么”，而不是直接命令你“买什么”。',
                highlightedTerms: <String>{'成交量', '估值'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '它不能直接命令我买卖。',
                myoResponse: '很好。让图表帮你提出“为什么”，而不是直接命令你“买什么”。',
                highlightedTerms: <String>{'成交量', '估值'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我会写下证据链。',
                myoResponse: '很好。让图表帮你提出“为什么”，而不是直接命令你“买什么”。',
                highlightedTerms: <String>{'成交量', '估值'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH04_C07',
            myoText: '这一章的安全句：行情图能帮你观察价格和活跃度，但不能替代研究和风险控制。',
            highlightedTerms: <String>{'成交量'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '我会把图当证据之一。',
                myoResponse: '对。图是证据之一，不是全部证据；下一章我们就问价格配不配资产。',
                highlightedTerms: <String>{'K 线', '估值'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '单一形态不重注。',
                myoResponse: '对。图是证据之一，不是全部证据；下一章我们就问价格配不配资产。',
                highlightedTerms: <String>{'K 线', '估值'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一步需要学估值。',
                myoResponse: '对。图是证据之一，不是全部证据；下一章我们就问价格配不配资产。',
                highlightedTerms: <String>{'K 线', '估值'},
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
            highlightedTerms: <String>{'估值', '股息率'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '股价高不一定贵。',
                myoResponse: '对。价格只是门口数字，估值要把价格和背后的质量放在一起看。',
                highlightedTerms: <String>{'估值'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '低价也不一定便宜。',
                myoResponse: '对。价格只是门口数字，估值要把价格和背后的质量放在一起看。',
                highlightedTerms: <String>{'估值'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '要把价格和东西一起看。',
                myoResponse: '对。价格只是门口数字，估值要把价格和背后的质量放在一起看。',
                highlightedTerms: <String>{'估值'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH05_C02',
            myoText: 'Myo 用小店打比方：同样要价 100 万，一家每年赚 20 万，一家每年赚 1 万，你会先问什么？',
            highlightedTerms: <String>{'估值'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '这价格对应多少利润？',
                myoResponse: '这就引出市盈率 PE：市场愿意为每 1 元利润付多少钱；但利润质量和持续性也要看。',
                highlightedTerms: <String>{'市盈率'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '利润能不能持续？',
                myoResponse: '这就引出市盈率 PE：市场愿意为每 1 元利润付多少钱；但利润质量和持续性也要看。',
                highlightedTerms: <String>{'市盈率'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '不能只看要价。',
                myoResponse: '这就引出市盈率 PE：市场愿意为每 1 元利润付多少钱；但利润质量和持续性也要看。',
                highlightedTerms: <String>{'市盈率'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH05_C03',
            myoText: '市盈率 PE 可以粗略理解为：市场愿意为公司每 1 元利润付多少钱。',
            highlightedTerms: <String>{'市盈率'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: 'PE 围绕利润定价。',
                myoResponse: '对。PE 是利润价格标签，但低 PE 可能是低估，也可能是市场担心利润下滑。',
                highlightedTerms: <String>{'市盈率'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: 'PE 越低不一定越好。',
                myoResponse: '对。PE 是利润价格标签，但低 PE 可能是低估，也可能是市场担心利润下滑。',
                highlightedTerms: <String>{'市盈率'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '亏损公司 PE 可能失灵。',
                myoResponse: '对。PE 是利润价格标签，但低 PE 可能是低估，也可能是市场担心利润下滑。',
                highlightedTerms: <String>{'市盈率'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH05_C04',
            myoText: '市净率 PB 看价格和净资产的关系，股息率看现金分红相对价格的大致比例。',
            highlightedTerms: <String>{'市净率', '股息率'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '不同指标回答不同问题。',
                myoResponse: '稳。先问指标回答什么，再组合看行业、公司质量和分红可持续性。',
                highlightedTerms: <String>{'市净率', '股息率', '估值'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '一个指标不能定生死。',
                myoResponse: '稳。先问指标回答什么，再组合看行业、公司质量和分红可持续性。',
                highlightedTerms: <String>{'市净率', '股息率', '估值'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '分红也不是永远固定。',
                myoResponse: '稳。先问指标回答什么，再组合看行业、公司质量和分红可持续性。',
                highlightedTerms: <String>{'市净率', '股息率', '估值'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH05_C05',
            myoText: '估值还要放进行业里比较：银行、白酒、科技、制造业，赚钱方式不同，合理区间也可能不同。',
            highlightedTerms: <String>{'估值'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '不能跨行业硬比。',
                myoResponse: '对。估值必须有参照系，历史区间、同行位置和现金流质量都要一起看。',
                highlightedTerms: <String>{'估值', '现金流'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '要看历史和同行。',
                myoResponse: '对。估值必须有参照系，历史区间、同行位置和现金流质量都要一起看。',
                highlightedTerms: <String>{'估值', '现金流'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '还要看增长质量。',
                myoResponse: '对。估值必须有参照系，历史区间、同行位置和现金流质量都要一起看。',
                highlightedTerms: <String>{'估值', '现金流'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH05_C06',
            myoText: '看到“便宜”两个字时，Myo 想让你多问一句：便宜的原因是什么？',
            highlightedTerms: <String>{'估值'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '是被低估，还是变差了？',
                myoResponse: '这是关键问题。低估值可能是机会，也可能是风险折价；便宜必须经过验证。',
                highlightedTerms: <String>{'估值', '市盈率'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '不能只看排行榜。',
                myoResponse: '这是关键问题。低估值可能是机会，也可能是风险折价；便宜必须经过验证。',
                highlightedTerms: <String>{'估值', '市盈率'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '低估值也可能是陷阱。',
                myoResponse: '这是关键问题。低估值可能是机会，也可能是风险折价；便宜必须经过验证。',
                highlightedTerms: <String>{'估值', '市盈率'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH05_C07',
            myoText: '这一章的概念路径：价格只是起点，PE/PB/股息率是工具，行业比较和质量验证决定“便宜”是否成立。',
            highlightedTerms: <String>{'市盈率', '市净率', '股息率', '估值'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '我会先问指标回答什么。',
                myoResponse: '很好。估值离不开公司质量，下一章我们看公司简历。',
                highlightedTerms: <String>{'估值'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我会验证便宜的原因。',
                myoResponse: '很好。估值离不开公司质量，下一章我们看公司简历。',
                highlightedTerms: <String>{'估值'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一章要认识公司。',
                myoResponse: '很好。估值离不开公司质量，下一章我们看公司简历。',
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
                myoResponse: '对。热搜不能替代商业模式，利润也要用现金流验证质量。',
                highlightedTerms: <String>{'现金流'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '利润和现金流都要看。',
                myoResponse: '对。热搜不能替代商业模式，利润也要用现金流验证质量。',
                highlightedTerms: <String>{'现金流'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我会先问它卖什么。',
                myoResponse: '对。热搜不能替代商业模式，利润也要用现金流验证质量。',
                highlightedTerms: <String>{'现金流'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH06_C02',
            myoText: 'Myo 把公司研究变成一份简历：客户是谁、产品是什么、收入从哪里来、成本受什么影响。',
            highlightedTerms: const <String>{},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先看主营业务。',
                myoResponse: '很好。主营业务回答“靠什么吃饭”，看不懂时先慢下来。',
                highlightedTerms: const <String>{},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '收入结构要拆开。',
                myoResponse: '很好。主营业务回答“靠什么吃饭”，看不懂时先慢下来。',
                highlightedTerms: const <String>{},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '听不懂的业务先放慢。',
                myoResponse: '很好。主营业务回答“靠什么吃饭”，看不懂时先慢下来。',
                highlightedTerms: const <String>{},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH06_C03',
            myoText: '利润像成绩单，但现金流像钱包。成绩好看，钱包长期没进钱，就要追问利润质量。',
            highlightedTerms: <String>{'现金流'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '利润和现金流背离要警惕。',
                myoResponse: '对。利润和现金流背离不等于直接定罪，但必须继续查。',
                highlightedTerms: <String>{'现金流'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '钱有没有收回来很重要。',
                myoResponse: '对。利润和现金流背离不等于直接定罪，但必须继续查。',
                highlightedTerms: <String>{'现金流'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '不能只看净利润增长。',
                myoResponse: '对。利润和现金流背离不等于直接定罪，但必须继续查。',
                highlightedTerms: <String>{'现金流'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH06_C04',
            myoText: '负债不是原罪，但负债过高会让公司在环境变差时更脆弱。',
            highlightedTerms: <String>{'负债'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '像家庭贷款压力。',
                myoResponse: '对。负债要结合行业、期限结构和偿债能力，不能只看一个数字。',
                highlightedTerms: <String>{'负债'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '负债越低也不一定越好。',
                myoResponse: '对。负债要结合行业、期限结构和偿债能力，不能只看一个数字。',
                highlightedTerms: <String>{'负债'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我要看资产负债率。',
                myoResponse: '对。负债要结合行业、期限结构和偿债能力，不能只看一个数字。',
                highlightedTerms: <String>{'负债'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH06_C05',
            myoText: '公司还会面对护城河和竞争：同样赚钱，能不能持续，取决于产品、品牌、成本、渠道和管理。',
            highlightedTerms: const <String>{},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '赚钱能否持续很关键。',
                myoResponse: '对。估值看未来，持续竞争力和治理质量会影响长期结果。',
                highlightedTerms: <String>{'估值', '公司风险'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '竞争会改变利润。',
                myoResponse: '对。估值看未来，持续竞争力和治理质量会影响长期结果。',
                highlightedTerms: <String>{'估值', '公司风险'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '管理层也会影响公司。',
                myoResponse: '对。估值看未来，持续竞争力和治理质量会影响长期结果。',
                highlightedTerms: <String>{'估值', '公司风险'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH06_C06',
            myoText: '公司研究不是为了找到完美公司，而是为了知道自己承担了什么风险。',
            highlightedTerms: <String>{'公司风险'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '没有公司是零风险。',
                myoResponse: '稳。故事负责吸引你，风险负责考验你；写下理由，未来才能复盘原假设。',
                highlightedTerms: <String>{'公司风险'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '看懂风险比听故事重要。',
                myoResponse: '稳。故事负责吸引你，风险负责考验你；写下理由，未来才能复盘原假设。',
                highlightedTerms: <String>{'公司风险'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我要写下买入理由。',
                myoResponse: '稳。故事负责吸引你，风险负责考验你；写下理由，未来才能复盘原假设。',
                highlightedTerms: <String>{'公司风险'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH06_C07',
            myoText: '这一章的顺序：业务、收入、利润、现金流、负债、竞争和风险提示。看完这些，再谈估值。',
            highlightedTerms: <String>{'现金流', '负债', '估值'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先体检，再报价。',
                myoResponse: '对。公司质量没看清，估值数字容易误导；下一章我们把风险来源分门别类。',
                highlightedTerms: <String>{'估值', '公司风险'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我不会只看概念题材。',
                myoResponse: '对。公司质量没看清，估值数字容易误导；下一章我们把风险来源分门别类。',
                highlightedTerms: <String>{'估值', '公司风险'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一章该学风险了。',
                myoResponse: '对。公司质量没看清，估值数字容易误导；下一章我们把风险来源分门别类。',
                highlightedTerms: <String>{'估值', '公司风险'},
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
                myoResponse: '对。风险来源不同，处理工具也不同；冲动、重仓和借钱都会把小波动放大。',
                highlightedTerms: <String>{'市场风险', '公司风险', '仓位'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我自己也会成为风险？',
                myoResponse: '对。风险来源不同，处理工具也不同；冲动、重仓和借钱都会把小波动放大。',
                highlightedTerms: <String>{'市场风险', '公司风险', '仓位'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下跌只是结果之一。',
                myoResponse: '对。风险来源不同，处理工具也不同；冲动、重仓和借钱都会把小波动放大。',
                highlightedTerms: <String>{'市场风险', '公司风险', '仓位'},
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
                text: '市场风险没法完全躲掉。',
                myoResponse: '很好。先分层，才知道用仓位、期限、资产配置还是公司研究来处理。',
                highlightedTerms: <String>{'市场风险', '公司风险', '资产配置'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '公司风险要靠研究。',
                myoResponse: '很好。先分层，才知道用仓位、期限、资产配置还是公司研究来处理。',
                highlightedTerms: <String>{'市场风险', '公司风险', '资产配置'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '两种风险不能混在一起。',
                myoResponse: '很好。先分层，才知道用仓位、期限、资产配置还是公司研究来处理。',
                highlightedTerms: <String>{'市场风险', '公司风险', '资产配置'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH07_C03',
            myoText: '分散像把鸡蛋放进多个篮子。它能降低单点风险，但不能让整场大雨消失。',
            highlightedTerms: <String>{'分散', '公司风险', '市场风险'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '分散能减少单家公司出事的伤害。',
                myoResponse: '对。分散降低单点风险，但不是数量越多越好，也不能消灭系统性波动。',
                highlightedTerms: <String>{'分散', '市场风险', '公司风险'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '分散不能消灭市场风险。',
                myoResponse: '对。分散降低单点风险，但不是数量越多越好，也不能消灭系统性波动。',
                highlightedTerms: <String>{'分散', '市场风险', '公司风险'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '分散不是乱买一堆。',
                myoResponse: '对。分散降低单点风险，但不是数量越多越好，也不能消灭系统性波动。',
                highlightedTerms: <String>{'分散', '市场风险', '公司风险'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH07_C04',
            myoText: '仓位决定一次波动会伤到你多少。新手最危险的动作之一，是借钱加仓。',
            highlightedTerms: <String>{'仓位'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '仓位像背包重量。',
                myoResponse: '对。背包太重，每一步波动都会更累；学习期先保留犯错空间。',
                highlightedTerms: <String>{'仓位'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '借钱会改变难度。',
                myoResponse: '对。背包太重，每一步波动都会更累；学习期先保留犯错空间。',
                highlightedTerms: <String>{'仓位'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '小额学习更稳。',
                myoResponse: '对。背包太重，每一步波动都会更累；学习期先保留犯错空间。',
                highlightedTerms: <String>{'仓位'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH07_C05',
            myoText: '现金缓冲也属于风险管理：它让你不用在最不舒服的时候被迫卖出。',
            highlightedTerms: <String>{'现金管理'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '现金能减少被迫卖出。',
                myoResponse: '稳。现金和应急金的职责不是冲收益，而是给生活系统留缓冲。',
                highlightedTerms: <String>{'现金管理', '应急金'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '应急金不是低效率。',
                myoResponse: '稳。现金和应急金的职责不是冲收益，而是给生活系统留缓冲。',
                highlightedTerms: <String>{'现金管理', '应急金'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '没有现金会放大焦虑。',
                myoResponse: '稳。现金和应急金的职责不是冲收益，而是给生活系统留缓冲。',
                highlightedTerms: <String>{'现金管理', '应急金'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH07_C06',
            myoText: '风险管理不是消灭波动，而是让波动不会摧毁你的生活和计划。',
            highlightedTerms: const <String>{},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '我需要风险上限。',
                myoResponse: '对。分散、现金、期限和仓位分别处理不同问题，不能只看收益。',
                highlightedTerms: <String>{'分散', '仓位'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '工具要配对风险来源。',
                myoResponse: '对。分散、现金、期限和仓位分别处理不同问题，不能只看收益。',
                highlightedTerms: <String>{'分散', '仓位'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我不能只追收益。',
                myoResponse: '对。分散、现金、期限和仓位分别处理不同问题，不能只看收益。',
                highlightedTerms: <String>{'分散', '仓位'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH07_C07',
            myoText: '这一章的概念路径：识别风险来源，再匹配工具；市场风险、公司风险、仓位风险和现金缓冲要分开看。',
            highlightedTerms: <String>{'市场风险', '公司风险', '仓位'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先看风险从哪里来。',
                myoResponse: '很好。来源看清，工具才不会乱；下一章用指数基金理解一篮子资产。',
                highlightedTerms: <String>{'指数基金', '分散'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '分散、仓位、现金一起用。',
                myoResponse: '很好。来源看清，工具才不会乱；下一章用指数基金理解一篮子资产。',
                highlightedTerms: <String>{'指数基金', '分散'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一章学一篮子资产。',
                myoResponse: '很好。来源看清，工具才不会乱；下一章用指数基金理解一篮子资产。',
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
                myoResponse: '对。指数基金规则相对透明，通常更分散，但分散不等于保本。',
                highlightedTerms: <String>{'指数基金', '分散'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '一篮子也会跌吗？',
                myoResponse: '对。指数基金规则相对透明，通常更分散，但分散不等于保本。',
                highlightedTerms: <String>{'指数基金', '分散'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '它比单只股票更分散。',
                myoResponse: '对。指数基金规则相对透明，通常更分散，但分散不等于保本。',
                highlightedTerms: <String>{'指数基金', '分散'},
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
                myoResponse: '稳。越窄越集中，弹性和风险都会更明显；先看篮子里装了谁。',
                highlightedTerms: <String>{'宽基', '分散'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '宽基不等于无风险。',
                myoResponse: '稳。越窄越集中，弹性和风险都会更明显；先看篮子里装了谁。',
                highlightedTerms: <String>{'宽基', '分散'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '主题名字不能替代持仓。',
                myoResponse: '稳。越窄越集中，弹性和风险都会更明显；先看篮子里装了谁。',
                highlightedTerms: <String>{'宽基', '分散'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH08_C03',
            myoText: '指数的规则会决定篮子里有什么、多久调整、按什么权重摆放。Myo 问：你会先查哪一项？',
            highlightedTerms: <String>{'指数基金'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先查跟踪什么指数。',
                myoResponse: '对。先知道篮子的目标规则、持仓权重和调整方式，再谈是否适合。',
                highlightedTerms: <String>{'指数基金'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '先查持仓和权重。',
                myoResponse: '对。先知道篮子的目标规则、持仓权重和调整方式，再谈是否适合。',
                highlightedTerms: <String>{'指数基金'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '先查调整规则。',
                myoResponse: '对。先知道篮子的目标规则、持仓权重和调整方式，再谈是否适合。',
                highlightedTerms: <String>{'指数基金'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH08_C04',
            myoText: '选基金时，新手先看费率、规模、跟踪稳定性和流动性。',
            highlightedTerms: <String>{'流动性'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '费用会长期影响结果。',
                myoResponse: '很好。低费率、足够规模、跟踪稳定和流动性，是基础筛选项。',
                highlightedTerms: <String>{'流动性', '指数基金'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '规模太小要小心。',
                myoResponse: '很好。低费率、足够规模、跟踪稳定和流动性，是基础筛选项。',
                highlightedTerms: <String>{'流动性', '指数基金'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '跟踪偏离也要看。',
                myoResponse: '很好。低费率、足够规模、跟踪稳定和流动性，是基础筛选项。',
                highlightedTerms: <String>{'流动性', '指数基金'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH08_C05',
            myoText: 'ETF 和普通场外基金的交易体验不同：有的在交易所买卖，有的按净值申赎。',
            highlightedTerms: <String>{'场内基金', '交易所'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '场内基金像股票一样在场内交易。',
                myoResponse: '对。场内价格受买卖盘影响，仍要看流动性；基金名字不能替代规则和持仓。',
                highlightedTerms: <String>{'场内基金', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '交易方式会影响价格体验。',
                myoResponse: '对。场内价格受买卖盘影响，仍要看流动性；基金名字不能替代规则和持仓。',
                highlightedTerms: <String>{'场内基金', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我不能只看基金名字。',
                myoResponse: '对。场内价格受买卖盘影响，仍要看流动性；基金名字不能替代规则和持仓。',
                highlightedTerms: <String>{'场内基金', '流动性'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH08_C06',
            myoText: '指数基金适合做学习入口，但不是“闭眼买”。规则透明，也要匹配期限和风险承受力。',
            highlightedTerms: <String>{'指数基金'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '友好不等于无风险。',
                myoResponse: '对。友好不等于无风险，再透明的篮子也要匹配资金期限。',
                highlightedTerms: <String>{'指数基金', '宽基'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '先选宽基，再理解行业主题。',
                myoResponse: '对。友好不等于无风险，再透明的篮子也要匹配资金期限。',
                highlightedTerms: <String>{'指数基金', '宽基'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '还要看我的资金期限。',
                myoResponse: '对。友好不等于无风险，再透明的篮子也要匹配资金期限。',
                highlightedTerms: <String>{'指数基金', '宽基'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH08_C07',
            myoText: '这一章的路径图：先认篮子规则，再分宽基/行业/主题，最后用费率、规模、跟踪和流动性筛选。',
            highlightedTerms: <String>{'宽基', '流动性'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '我会先看篮子里有什么。',
                myoResponse: '很好。持仓比名字更诚实；下一章我们把站岗的钱放回安全位置。',
                highlightedTerms: <String>{'分散', '固收', '现金管理'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我会把分散和保本分开。',
                myoResponse: '很好。持仓比名字更诚实；下一章我们把站岗的钱放回安全位置。',
                highlightedTerms: <String>{'分散', '固收', '现金管理'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一章该处理现金和固收。',
                myoResponse: '很好。持仓比名字更诚实；下一章我们把站岗的钱放回安全位置。',
                highlightedTerms: <String>{'分散', '固收', '现金管理'},
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
                myoResponse: '对。应急金像备用钥匙，关键时刻要能打开门；用途决定优先级。',
                highlightedTerms: <String>{'应急金', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '它不是用来冲收益。',
                myoResponse: '对。应急金像备用钥匙，关键时刻要能打开门；用途决定优先级。',
                highlightedTerms: <String>{'应急金', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '流动性比收益优先。',
                myoResponse: '对。应急金像备用钥匙，关键时刻要能打开门；用途决定优先级。',
                highlightedTerms: <String>{'应急金', '流动性'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH09_C02',
            myoText: 'Myo 让你给钱贴标签：随时要用、1 年内要用、5 年以上不用。标签不同，工具就不同。',
            highlightedTerms: const <String>{},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '短期钱先保用途。',
                myoResponse: '很好。钱有任务，资产才有岗位；期限越短，越不能承受大波动。',
                highlightedTerms: <String>{'资产配置', '权益'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '长期闲钱才谈波动承受。',
                myoResponse: '很好。钱有任务，资产才有岗位；期限越短，越不能承受大波动。',
                highlightedTerms: <String>{'资产配置', '权益'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '按期限分层。',
                myoResponse: '很好。钱有任务，资产才有岗位；期限越短，越不能承受大波动。',
                highlightedTerms: <String>{'资产配置', '权益'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH09_C03',
            myoText: '固收听起来稳，但债券和债基也会受利率、信用、期限影响。',
            highlightedTerms: <String>{'固收', '债券', '债基'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '固收也会波动。',
                myoResponse: '对。固收通常波动更低，但不是静止，产品名字不能替代底层资产分析。',
                highlightedTerms: <String>{'固收', '债券'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '债券像借条。',
                myoResponse: '对。固收通常波动更低，但不是静止，产品名字不能替代底层资产分析。',
                highlightedTerms: <String>{'固收', '债券'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '名字稳不代表保本。',
                myoResponse: '对。固收通常波动更低，但不是静止，产品名字不能替代底层资产分析。',
                highlightedTerms: <String>{'固收', '债券'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH09_C04',
            myoText: '利率变化像跷跷板，会影响债券价格；信用风险则是在问借款方能不能按约还钱。',
            highlightedTerms: <String>{'债券'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '债券价格也会变。',
                myoResponse: '稳。收益更高时要问风险从哪里来，短期钱尤其要谨慎。',
                highlightedTerms: <String>{'债券', '固收'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '信用风险不能忽略。',
                myoResponse: '稳。收益更高时要问风险从哪里来，短期钱尤其要谨慎。',
                highlightedTerms: <String>{'债券', '固收'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '期限越长波动可能越明显。',
                myoResponse: '稳。收益更高时要问风险从哪里来，短期钱尤其要谨慎。',
                highlightedTerms: <String>{'债券', '固收'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH09_C05',
            myoText: '现金管理、货币工具、短债、债基，不是同一种东西。Myo 想让你问：底层资产是什么？',
            highlightedTerms: <String>{'现金管理', '债基'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '我要看底层资产。',
                myoResponse: '对。工具名字只是入口，底层资产、赎回安排和流动性才决定主要体验。',
                highlightedTerms: <String>{'现金管理', '债基', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '货币工具通常更偏流动性。',
                myoResponse: '对。工具名字只是入口，底层资产、赎回安排和流动性才决定主要体验。',
                highlightedTerms: <String>{'现金管理', '债基', '流动性'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '债基要看久期和信用。',
                myoResponse: '对。工具名字只是入口，底层资产、赎回安排和流动性才决定主要体验。',
                highlightedTerms: <String>{'现金管理', '债基', '流动性'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH09_C06',
            myoText: '明年要交学费的钱，不适合坐过山车。资金期限越短，越不能承受大波动。',
            highlightedTerms: const <String>{},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '短期刚需钱不能冒大险。',
                myoResponse: '对。钱的任务越硬，风险预算越低；先保护用途，再谈收益。',
                highlightedTerms: <String>{'应急金'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '不能为了多一点收益牺牲确定性。',
                myoResponse: '对。钱的任务越硬，风险预算越低；先保护用途，再谈收益。',
                highlightedTerms: <String>{'应急金'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我会先留生活安全垫。',
                myoResponse: '对。钱的任务越硬，风险预算越低；先保护用途，再谈收益。',
                highlightedTerms: <String>{'应急金'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH09_C07',
            myoText: '这一章的路径图：先分资金期限，再确定应急金、现金管理和固收工具，最后检查流动性、利率和信用风险。',
            highlightedTerms: <String>{'应急金', '现金管理', '固收', '流动性'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '用途决定工具。',
                myoResponse: '很好。稳定器也有说明书；工具摆好后，还要给情绪装暂停键。',
                highlightedTerms: <String>{'固收', '从众', '损失厌恶'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '稳定器也有说明书。',
                myoResponse: '很好。稳定器也有说明书；工具摆好后，还要给情绪装暂停键。',
                highlightedTerms: <String>{'固收', '从众', '损失厌恶'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一章处理情绪。',
                myoResponse: '很好。稳定器也有说明书；工具摆好后，还要给情绪装暂停键。',
                highlightedTerms: <String>{'固收', '从众', '损失厌恶'},
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
                myoResponse: '对。识别从众的第一步，是承认热闹会给自己压力。',
                highlightedTerms: <String>{'从众'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我会怕错过。',
                myoResponse: '对。识别从众的第一步，是承认热闹会给自己压力。',
                highlightedTerms: <String>{'从众'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '大家赚钱会让我冲动。',
                myoResponse: '对。识别从众的第一步，是承认热闹会给自己压力。',
                highlightedTerms: <String>{'从众'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH10_C02',
            myoText: 'Myo 设计一个场景：群里都在晒收益，你本来没研究，却突然想立刻买。你会先问什么？',
            highlightedTerms: <String>{'从众'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '这是我的理由，还是别人的情绪？',
                myoResponse: '非常好。把理由和气氛分开，冷静期能让冲动先降温。',
                highlightedTerms: <String>{'从众'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我有没有完整证据？',
                myoResponse: '非常好。把理由和气氛分开，冷静期能让冲动先降温。',
                highlightedTerms: <String>{'从众'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '能不能先冷静一天？',
                myoResponse: '非常好。把理由和气氛分开，冷静期能让冲动先降温。',
                highlightedTerms: <String>{'从众'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH10_C03',
            myoText: '损失厌恶会让人不愿承认亏损，甚至为了不难受而拖延决策。',
            highlightedTerms: <String>{'损失厌恶'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '亏损会让我想逃避。',
                myoResponse: '对。规则的作用就是在难受时给你扶手，帮你回到原假设和事实。',
                highlightedTerms: <String>{'损失厌恶'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '不看账户也不能解决问题。',
                myoResponse: '对。规则的作用就是在难受时给你扶手，帮你回到原假设和事实。',
                highlightedTerms: <String>{'损失厌恶'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '要回到买入理由。',
                myoResponse: '对。规则的作用就是在难受时给你扶手，帮你回到原假设和事实。',
                highlightedTerms: <String>{'损失厌恶'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH10_C04',
            myoText: '过度自信也常见：一次赚钱后，容易把运气误认成能力，然后把仓位越放越大。',
            highlightedTerms: <String>{'仓位'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '赚一次不代表方法稳定。',
                myoResponse: '稳。一次结果可能有运气成分，仓位上限和投资日志能防止风险失控。',
                highlightedTerms: <String>{'仓位'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '仓位不能因为兴奋失控。',
                myoResponse: '稳。一次结果可能有运气成分，仓位上限和投资日志能防止风险失控。',
                highlightedTerms: <String>{'仓位'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我要记录当时为什么买。',
                myoResponse: '稳。一次结果可能有运气成分，仓位上限和投资日志能防止风险失控。',
                highlightedTerms: <String>{'仓位'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH10_C05',
            myoText: '冷静期、仓位上限和投资日志，是给情绪准备的三个工具。',
            highlightedTerms: <String>{'仓位'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '冷静期延迟冲动。',
                myoResponse: '对。先慢下来、限制伤害、留下原因，情绪最吵时才有抓手。',
                highlightedTerms: <String>{'仓位'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '仓位上限限制伤害。',
                myoResponse: '对。先慢下来、限制伤害、留下原因，情绪最吵时才有抓手。',
                highlightedTerms: <String>{'仓位'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '投资日志帮助复盘。',
                myoResponse: '对。先慢下来、限制伤害、留下原因，情绪最吵时才有抓手。',
                highlightedTerms: <String>{'仓位'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH10_C06',
            myoText: 'Myo 还想加一个动作：把规则写在冲动之前。等情绪来了再写，通常已经太晚。',
            highlightedTerms: const <String>{},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先写买入条件。',
                myoResponse: '很好。条件、退出、暂停和复盘都要提前写，并且简单到真的能执行。',
                highlightedTerms: const <String>{},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '也要写卖出和暂停条件。',
                myoResponse: '很好。条件、退出、暂停和复盘都要提前写，并且简单到真的能执行。',
                highlightedTerms: const <String>{},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '规则要简单到能执行。',
                myoResponse: '很好。条件、退出、暂停和复盘都要提前写，并且简单到真的能执行。',
                highlightedTerms: const <String>{},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH10_C07',
            myoText: '这一章不是让你没有情绪，而是让情绪最吵的时候，动作更慢一点。',
            highlightedTerms: const <String>{},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先暂停，再决策。',
                myoResponse: '对。暂停键比预测更实用；下一章的定投就是把猜时点改成按规则执行。',
                highlightedTerms: <String>{'定投'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '规则写在冲动之前。',
                myoResponse: '对。暂停键比预测更实用；下一章的定投就是把猜时点改成按规则执行。',
                highlightedTerms: <String>{'定投'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '下一章用规则定投。',
                myoResponse: '对。暂停键比预测更实用；下一章的定投就是把猜时点改成按规则执行。',
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
                myoResponse: '对。定投不保证结果，但能减少“必须一次猜对”的压力。',
                highlightedTerms: <String>{'定投'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '定投也会亏吗？',
                myoResponse: '对。定投不保证结果，但能减少“必须一次猜对”的压力。',
                highlightedTerms: <String>{'定投'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '规则比情绪更稳定。',
                myoResponse: '对。定投不保证结果，但能减少“必须一次猜对”的压力。',
                highlightedTerms: <String>{'定投'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH11_C02',
            myoText: 'Myo 用买水果打比方：你不确定哪天最便宜，于是按固定金额分批买，价格高买少点，价格低买多点。',
            highlightedTerms: <String>{'定投'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '固定金额会自动买多买少。',
                myoResponse: '对。定投解决投入节奏，不解决资产质量，也不是短线魔法。',
                highlightedTerms: <String>{'定投'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '但前提是东西值得长期买。',
                myoResponse: '对。定投解决投入节奏，不解决资产质量，也不是短线魔法。',
                highlightedTerms: <String>{'定投'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '这不是短线技巧。',
                myoResponse: '对。定投解决投入节奏，不解决资产质量，也不是短线魔法。',
                highlightedTerms: <String>{'定投'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH11_C03',
            myoText: '微笑曲线成立有前提：资产长期有恢复和增长机会，你也有能力持续执行。',
            highlightedTerms: <String>{'定投'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '不是所有下跌都会微笑。',
                myoResponse: '没错。没有长期修复，曲线不会自己变好；现金流和执行能力同样重要。',
                highlightedTerms: <String>{'定投', '现金流'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '现金流要撑得住。',
                myoResponse: '没错。没有长期修复，曲线不会自己变好；现金流和执行能力同样重要。',
                highlightedTerms: <String>{'定投', '现金流'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '执行能力也是条件。',
                myoResponse: '没错。没有长期修复，曲线不会自己变好；现金流和执行能力同样重要。',
                highlightedTerms: <String>{'定投', '现金流'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH11_C04',
            myoText: '一个可执行定投计划，至少要写清楚金额、频率、资产、暂停条件和复盘时间。',
            highlightedTerms: <String>{'定投'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '金额不能挤压生活。',
                myoResponse: '对。长期执行不等于永远不检查，计划必须具体且可承受。',
                highlightedTerms: <String>{'定投'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '频率固定更容易执行。',
                myoResponse: '对。长期执行不等于永远不检查，计划必须具体且可承受。',
                highlightedTerms: <String>{'定投'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '还要设置复盘。',
                myoResponse: '对。长期执行不等于永远不检查，计划必须具体且可承受。',
                highlightedTerms: <String>{'定投'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH11_C05',
            myoText: '如果收入不稳定，Myo 不建议硬撑大额计划。小额、弹性、先留应急金，更可能长期执行。',
            highlightedTerms: <String>{'应急金', '定投'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先留应急金再定投。',
                myoResponse: '稳。安全垫在前，长期计划在后；能持续的小计划比坚持不了的大计划更真实。',
                highlightedTerms: <String>{'应急金', '定投'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '金额要跟收入稳定性匹配。',
                myoResponse: '稳。安全垫在前，长期计划在后；能持续的小计划比坚持不了的大计划更真实。',
                highlightedTerms: <String>{'应急金', '定投'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '小计划也有价值。',
                myoResponse: '稳。安全垫在前，长期计划在后；能持续的小计划比坚持不了的大计划更真实。',
                highlightedTerms: <String>{'应急金', '定投'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH11_C06',
            myoText: '定投也需要退出和暂停规则：资产逻辑变了、资金用途变了、风险超出承受力，都要复盘。',
            highlightedTerms: <String>{'定投'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '长期不等于永远不管。',
                myoResponse: '对。长期主义不是闭眼，原假设或资金任务变化时要重新检查。',
                highlightedTerms: <String>{'定投', '资产配置'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '资产逻辑变了要停下来。',
                myoResponse: '对。长期主义不是闭眼，原假设或资金任务变化时要重新检查。',
                highlightedTerms: <String>{'定投', '资产配置'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '资金用途变了也要调整。',
                myoResponse: '对。长期主义不是闭眼，原假设或资金任务变化时要重新检查。',
                highlightedTerms: <String>{'定投', '资产配置'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH11_C07',
            myoText: '定投真正训练的是长期规则感：少问“明天涨吗”，多问“这个计划我能坚持吗”。',
            highlightedTerms: <String>{'定投'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '能坚持比金额大更重要。',
                myoResponse: '很好。把重复决策变成固定流程，就是定投的价值；下一章把资产放回各自岗位。',
                highlightedTerms: <String>{'定投', '固收', '权益'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '规则替我减少纠结。',
                myoResponse: '很好。把重复决策变成固定流程，就是定投的价值；下一章把资产放回各自岗位。',
                highlightedTerms: <String>{'定投', '固收', '权益'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '最后要搭组合。',
                myoResponse: '很好。把重复决策变成固定流程，就是定投的价值；下一章把资产放回各自岗位。',
                highlightedTerms: <String>{'定投', '固收', '权益'},
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
                myoResponse: '对。现金、固收、权益不是互相替代，而是各自服务不同资金任务。',
                highlightedTerms: <String>{'资产配置', '固收', '权益'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '固收做稳定器。',
                myoResponse: '对。现金、固收、权益不是互相替代，而是各自服务不同资金任务。',
                highlightedTerms: <String>{'资产配置', '固收', '权益'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '权益承担长期成长。',
                myoResponse: '对。现金、固收、权益不是互相替代，而是各自服务不同资金任务。',
                highlightedTerms: <String>{'资产配置', '固收', '权益'},
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
                myoResponse: '非常重要。钱有任务，资产才有岗位；短期钱不能赌长期修复。',
                highlightedTerms: <String>{'资产配置'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '用途比热点重要。',
                myoResponse: '非常重要。钱有任务，资产才有岗位；短期钱不能赌长期修复。',
                highlightedTerms: <String>{'资产配置'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '能等才有承受波动的空间。',
                myoResponse: '非常重要。钱有任务，资产才有岗位；短期钱不能赌长期修复。',
                highlightedTerms: <String>{'资产配置'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH12_C03',
            myoText: 'Myo 让你把资金分三层：应急金、短中期目标、长期成长资金。每层的资产岗位不同。',
            highlightedTerms: <String>{'应急金', '资产配置'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '应急金先保证可用。',
                myoResponse: '对。应急金负责救场，短中期目标保护用途，长期资金才有更多权益空间。',
                highlightedTerms: <String>{'应急金', '权益'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '短中期目标要少波动。',
                myoResponse: '对。应急金负责救场，短中期目标保护用途，长期资金才有更多权益空间。',
                highlightedTerms: <String>{'应急金', '权益'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '长期资金才考虑权益。',
                myoResponse: '对。应急金负责救场，短中期目标保护用途，长期资金才有更多权益空间。',
                highlightedTerms: <String>{'应急金', '权益'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH12_C04',
            myoText: '组合不是只买一种，也不是把所有工具平均分。比例要来自用途、期限和承受力。',
            highlightedTerms: <String>{'资产配置'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '平均分不一定适合。',
                myoResponse: '稳。比例不是数学平均，而是需求匹配；仓位上限让组合不因单类资产失控。',
                highlightedTerms: <String>{'资产配置', '仓位'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '资产各司其职。',
                myoResponse: '稳。比例不是数学平均，而是需求匹配；仓位上限让组合不因单类资产失控。',
                highlightedTerms: <String>{'资产配置', '仓位'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '仓位要有上限。',
                myoResponse: '稳。比例不是数学平均，而是需求匹配；仓位上限让组合不因单类资产失控。',
                highlightedTerms: <String>{'资产配置', '仓位'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH12_C05',
            myoText: '再平衡像定期整理工具箱：某类资产涨太多或跌太多，比例偏离了，就按规则拉回目标区间。',
            highlightedTerms: <String>{'资产配置'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '再平衡不是追涨杀跌。',
                myoResponse: '对。再平衡是让组合回到原来的风险设计，而不是每天被波动牵着跑。',
                highlightedTerms: <String>{'资产配置'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '要先有目标比例。',
                myoResponse: '对。再平衡是让组合回到原来的风险设计，而不是每天被波动牵着跑。',
                highlightedTerms: <String>{'资产配置'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '频率不能太随意。',
                myoResponse: '对。再平衡是让组合回到原来的风险设计，而不是每天被波动牵着跑。',
                highlightedTerms: <String>{'资产配置'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH12_C06',
            myoText: '完成 12 章后，Myo 不想让你马上冲锋，而是写一张个人系统草稿：资金分层、风险上限、定投计划、复盘习惯。',
            highlightedTerms: <String>{'定投'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '我先写自己的资金分层。',
                myoResponse: '很好。系统草稿比立刻交易更重要，学习到行动之间可以先低风险验证流程。',
                highlightedTerms: <String>{'资产配置', '定投'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '我会保留复盘入口。',
                myoResponse: '很好。系统草稿比立刻交易更重要，学习到行动之间可以先低风险验证流程。',
                highlightedTerms: <String>{'资产配置', '定投'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: '我会先模拟或小额实践。',
                myoResponse: '很好。系统草稿比立刻交易更重要，学习到行动之间可以先低风险验证流程。',
                highlightedTerms: <String>{'资产配置', '定投'},
              ),
            ],
          ),
          GuidanceConceptTurn(
            id: 'CH12_C07',
            myoText: '终章概念路径：先定资金任务，再分现金、固收、权益岗位，最后用仓位、定投和复盘维护系统。',
            highlightedTerms: <String>{'资产配置', '固收', '权益', '仓位', '定投'},
            options: <GuidanceConceptOption>[
              GuidanceConceptOption(
                id: 'A',
                text: '先有系统，再谈行动。',
                myoResponse: '这就是终章答案：先有系统，再谈行动；学完 12 章，是你开始建立个人投资规则。',
                highlightedTerms: <String>{'资产配置'},
              ),
              GuidanceConceptOption(
                id: 'B',
                text: '每类资产都有岗位。',
                myoResponse: '这就是终章答案：先有系统，再谈行动；学完 12 章，是你开始建立个人投资规则。',
                highlightedTerms: <String>{'资产配置'},
              ),
              GuidanceConceptOption(
                id: 'C',
                text: 'Myo，我们从学习开始。',
                myoResponse: '这就是终章答案：先有系统，再谈行动；学完 12 章，是你开始建立个人投资规则。',
                highlightedTerms: <String>{'资产配置'},
              ),
            ],
          ),
        ],
      ),
    };
