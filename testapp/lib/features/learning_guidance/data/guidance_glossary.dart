// Last Updated: 2026-04-25
// 最后更新: 2026-04-25
//
// Module: Guidance glossary data - beginner-friendly finance term explanations
// 模块: 投资者教育术语表 - 面向新手的金融术语解释
//
// Dependencies: None
// 依赖: 无
//
// Author: Harry Chen / AI
// Email: 11911421@mail.sustech.edu.cn

class GuidanceGlossaryTerm {
  const GuidanceGlossaryTerm({
    required this.term,
    required this.aliases,
    required this.plainExplanation,
    required this.example,
  });

  final String term;
  final List<String> aliases;
  final String plainExplanation;
  final String example;
}

const List<GuidanceGlossaryTerm> guidanceGlossaryTerms = <GuidanceGlossaryTerm>[
  GuidanceGlossaryTerm(
    term: '二级市场',
    aliases: <String>['二级市场'],
    plainExplanation: '已经发行出来的股票、基金、债券，在投资者之间互相转让的市场。',
    example: '像二手平台：你买到东西，钱主要给卖家，不是给最初生产它的人。',
  ),
  GuidanceGlossaryTerm(
    term: '一级市场',
    aliases: <String>['一级市场'],
    plainExplanation: '公司或发行人第一次把证券卖出去融资的地方。',
    example: '像新店第一次卖会员卡，钱直接进店里。',
  ),
  GuidanceGlossaryTerm(
    term: 'IPO',
    aliases: <String>['IPO', '首次公开发行', '公开发行'],
    plainExplanation: '公司第一次向公众发行股票并准备上市交易的过程。',
    example: '像一家店第一次把会员卡公开卖给更多人，募集来的钱主要进入公司。',
  ),
  GuidanceGlossaryTerm(
    term: '发行方',
    aliases: <String>['发行方', '发行人'],
    plainExplanation: '把证券拿出来发行融资的一方，通常是公司。',
    example: '在 IPO 里，公司就是把股份拿出来募集资金的发行方。',
  ),
  GuidanceGlossaryTerm(
    term: '股份',
    aliases: <String>['股份', '份额'],
    plainExplanation: '公司所有权被切成的小份，持有股份代表拥有公司的一部分权益。',
    example: '像把一张大披萨切成很多小块，每一块都是一份股份。',
  ),
  GuidanceGlossaryTerm(
    term: '承销商',
    aliases: <String>['承销商', '主承销商'],
    plainExplanation: '协助发行方设计发行方案、定价、路演和销售证券的金融机构。',
    example: '像帮新店开张卖会员卡的专业团队，负责把发行安排好。',
  ),
  GuidanceGlossaryTerm(
    term: '基石投资者',
    aliases: <String>['基石投资者'],
    plainExplanation: '在发行阶段提前承诺认购较大份额的投资者，常用于增强市场信心。',
    example: '像开售前先有人承诺买一大批票，给其他人一个参考锚点。',
  ),
  GuidanceGlossaryTerm(
    term: '打新',
    aliases: <String>['打新', '新股申购', '申购新股'],
    plainExplanation: '投资者在新股发行阶段申请认购股份的行为。',
    example: '像新票开售时提交购买申请，但不代表一定能全部买到。',
  ),
  GuidanceGlossaryTerm(
    term: '散户',
    aliases: <String>['散户', '普通投资者'],
    plainExplanation: '资金规模相对较小、以个人为主的投资者群体。',
    example: '在打新里，散户通常通过券商账户提交新股申购。',
  ),
  GuidanceGlossaryTerm(
    term: '破发',
    aliases: <String>['破发', '跌破发行价'],
    plainExplanation: '股票上市交易后，市场价格跌到发行价以下。',
    example: '如果发行价是 10 元，上市后跌到 9 元，就叫破发。',
  ),
  GuidanceGlossaryTerm(
    term: '证券',
    aliases: <String>['证券', '已发行证券'],
    plainExplanation: '代表某种权益或债权的凭证，常见有股票、债券、基金份额。',
    example: '它像一张“你拥有某种金融关系”的票据。',
  ),
  GuidanceGlossaryTerm(
    term: '股票',
    aliases: <String>['股票'],
    plainExplanation: '公司所有权的一小份。持有股票不等于管理公司，但会承担价格波动。',
    example: '像共同拥有一家店的一小片份额。',
  ),
  GuidanceGlossaryTerm(
    term: '债券',
    aliases: <String>['债券'],
    plainExplanation: '借钱给发行人的凭证，到期和利息规则写在产品条款里。',
    example: '更像一张借条，但仍要看借款方信用和利率变化。',
  ),
  GuidanceGlossaryTerm(
    term: '场内基金',
    aliases: <String>['场内基金', 'ETF', '指数基金', '宽基指数', '宽基'],
    plainExplanation: '可以在交易所买卖的基金，很多产品会跟踪一篮子股票或债券。',
    example: '像买一个透明篮子，而不是只押一个水果。',
  ),
  GuidanceGlossaryTerm(
    term: '指数基金',
    aliases: <String>['指数基金', 'ETF', '场内基金'],
    plainExplanation: '按照指数规则持有一篮子资产的基金，目标是尽量跟踪某个指数表现。',
    example: '像照着菜谱装篮子，规则比故事更重要。',
  ),
  GuidanceGlossaryTerm(
    term: '宽基',
    aliases: <String>['宽基', '宽基指数'],
    plainExplanation: '覆盖较广市场代表性资产的指数类型，通常比行业或主题更分散。',
    example: '像买市场大篮子，而不是只买一个货架。',
  ),
  GuidanceGlossaryTerm(
    term: '流动性',
    aliases: <String>['流动性'],
    plainExplanation: '想买或想卖时，能不能比较顺利成交。',
    example: '像门能不能打开。门好开，不代表屋里一定有宝贝。',
  ),
  GuidanceGlossaryTerm(
    term: '交易所',
    aliases: <String>['交易所', '沪市', '深市', '北交所', '上交所', '深交所'],
    plainExplanation: '组织证券买卖、制定交易规则的市场场所。',
    example: '像有规则和门牌号的集市。',
  ),
  GuidanceGlossaryTerm(
    term: '板块',
    aliases: <String>['板块', '主板', '创业板', '科创板'],
    plainExplanation: '把相似市场、行业或规则下的公司放在一起看的分类。',
    example: '像城市里的不同小区，规则和风险气质会不一样。',
  ),
  GuidanceGlossaryTerm(
    term: '交易时间',
    aliases: <String>['交易时间', '交易时段', '连续竞价', '集合竞价'],
    plainExplanation: '市场允许集中成交的时间窗口，不是全天都按同样规则交易。',
    example: '像快递揽收时间，错过窗口就要等下一段。',
  ),
  GuidanceGlossaryTerm(
    term: '市价委托',
    aliases: <String>['市价委托', '市价单'],
    plainExplanation: '优先追求尽快成交的下单方式，实际成交价可能和预想不同。',
    example: '像说“现在能买到就买”，速度更快，但价格不一定最舒服。',
  ),
  GuidanceGlossaryTerm(
    term: '涨跌幅',
    aliases: <String>['涨跌幅', '涨跌停'],
    plainExplanation: '单个交易日价格上下波动的规则边界，不同板块可能不同。',
    example: '像给价格装护栏，但护栏不等于不会跌。',
  ),
  GuidanceGlossaryTerm(
    term: 'K 线',
    aliases: <String>['K 线', '行情图', '分时', '日线', '周线'],
    plainExplanation: '记录价格变化的图，不是预测未来的水晶球。',
    example: '像体温记录表：记录变化，但不能单独诊断全部问题。',
  ),
  GuidanceGlossaryTerm(
    term: '成交量',
    aliases: <String>['成交量'],
    plainExplanation: '某段时间里成交了多少，代表交易活跃程度。',
    example: '像店里人流量变大，只说明热闹，不代表商品一定更好。',
  ),
  GuidanceGlossaryTerm(
    term: '估值',
    aliases: <String>['估值', '低估值'],
    plainExplanation: '把价格和利润、资产、分红、成长放在一起看，判断贵不贵。',
    example: '同样 100 元，买水可能贵，买外套可能合理。',
  ),
  GuidanceGlossaryTerm(
    term: '市盈率',
    aliases: <String>['市盈率', 'PE'],
    plainExplanation: '市场愿意为公司每 1 元利润付多少价格。',
    example: '像“利润价格标签”，但不能单独决定能不能买。',
  ),
  GuidanceGlossaryTerm(
    term: '市净率',
    aliases: <String>['市净率', 'PB'],
    plainExplanation: '价格和公司净资产之间的比例。',
    example: '像看这家公司账面家底和市场标价的关系。',
  ),
  GuidanceGlossaryTerm(
    term: '股息率',
    aliases: <String>['股息率', '分红'],
    plainExplanation: '每年现金分红相对当前价格的大致比例。',
    example: '像房租回报率，但分红不是永远固定。',
  ),
  GuidanceGlossaryTerm(
    term: '现金流',
    aliases: <String>['现金流', '经营现金流'],
    plainExplanation: '公司真金白银流进流出的情况，是观察利润质量的重要线索。',
    example: '账面说赚钱了，也要看钱有没有真的收回来。',
  ),
  GuidanceGlossaryTerm(
    term: '负债',
    aliases: <String>['负债', '资产负债率'],
    plainExplanation: '公司欠的钱和杠杆压力，过高时会增加经营风险。',
    example: '像家庭贷款，收入稳定时能承受，压力太大就危险。',
  ),
  GuidanceGlossaryTerm(
    term: '市场风险',
    aliases: <String>['市场风险', '系统性波动', '大盘波动'],
    plainExplanation: '整个市场环境变化带来的波动，单靠买很多家公司也不能完全消除。',
    example: '像下大雨，路上大多数人都会被影响。',
  ),
  GuidanceGlossaryTerm(
    term: '公司风险',
    aliases: <String>['公司风险', '单点风险'],
    plainExplanation: '单家公司经营、财务或治理出现问题带来的风险。',
    example: '像某一段路塌了，影响的是走这条路的人。',
  ),
  GuidanceGlossaryTerm(
    term: '分散',
    aliases: <String>['分散', '分散投资'],
    plainExplanation: '不把钱全压在一个点上，用多个资产降低单点出问题的伤害。',
    example: '像不把所有鸡蛋放进同一个篮子。',
  ),
  GuidanceGlossaryTerm(
    term: '应急金',
    aliases: <String>['应急金', '现金管理'],
    plainExplanation: '为突发支出准备的钱，优先安全和随时可用。',
    example: '像家里的备用钥匙，平时不起眼，关键时刻要能用。',
  ),
  GuidanceGlossaryTerm(
    term: '现金管理',
    aliases: <String>['现金管理', '应急金', '货币工具'],
    plainExplanation: '管理短期和随时可用资金的工具或方法，优先安全性和流动性。',
    example: '像把常用工具放在最容易拿到的位置。',
  ),
  GuidanceGlossaryTerm(
    term: '固收',
    aliases: <String>['固收', '短债', '债基', '货币工具'],
    plainExplanation: '以债券、货币等低波动资产为主的工具，但也不是完全不波动。',
    example: '像组合里的稳定器，不是加速器。',
  ),
  GuidanceGlossaryTerm(
    term: '债基',
    aliases: <String>['债基', '债券基金'],
    plainExplanation: '主要投资债券的基金，会受到利率、信用和期限等因素影响。',
    example: '像把多张借条装进一个产品里，仍要看借款质量。',
  ),
  GuidanceGlossaryTerm(
    term: '权益',
    aliases: <String>['权益', '权益市场', '权益基金'],
    plainExplanation: '和股票所有权相关的一类资产，长期可能有成长，但波动通常更明显。',
    example: '像成长仓，需要更长时间和更强承受力。',
  ),
  GuidanceGlossaryTerm(
    term: '从众',
    aliases: <String>['从众', 'FOMO', '错失恐惧'],
    plainExplanation: '看到别人都在做，就担心自己错过而冲动行动。',
    example: '朋友圈都在晒收益，不代表这就是你的买入理由。',
  ),
  GuidanceGlossaryTerm(
    term: '损失厌恶',
    aliases: <String>['损失厌恶'],
    plainExplanation: '人们通常对亏损更敏感，容易为了不承认亏损而拖延决策。',
    example: '像不愿拆开一张坏成绩单，但不看它也不会变好。',
  ),
  GuidanceGlossaryTerm(
    term: '仓位',
    aliases: <String>['仓位', '仓位上限', '重仓'],
    plainExplanation: '某类资产占你总资金的比例，决定一次波动会伤到你多少。',
    example: '像背包重量，太重时每一步都更累。',
  ),
  GuidanceGlossaryTerm(
    term: '定投',
    aliases: <String>['定投', '微笑曲线'],
    plainExplanation: '按固定规则分批投入，降低一次猜时点的压力，但不保证盈利。',
    example: '像每月固定存钱，重点是可承受和长期执行。',
  ),
  GuidanceGlossaryTerm(
    term: '资产配置',
    aliases: <String>['资产配置', '组合', '稳健组合'],
    plainExplanation: '把现金、固收、权益等放在不同岗位上，让钱服务不同期限和用途。',
    example: '像工具箱：锤子、尺子、螺丝刀各有工作。',
  ),
];
