// ReMotion AI · 手表端（合成数据演示，不联网，不构成医疗或适岗结论）
// 放入 DevEco Studio 的 Wearable 工程：entry/src/main/ets/pages/Index.ets
@Entry
@Component
struct Index {
  @State sc: number = 0            // 情景：0 正常 1 热应激提示 2 信号丢失
  @State hr: number = 84
  @State ack: boolean = false
  private hrId: number = -1
  private names: string[] = ['正常', '热应激提示', '信号丢失']
  private risk: number[] = [42, 68, 55]

  aboutToAppear() {
    this.hrId = setInterval(() => {
      this.hr = Math.max(70, Math.min(112, this.hr + Math.floor(Math.random() * 5) - 2))
    }, 2500)
  }
  aboutToDisappear() { clearInterval(this.hrId) }

  next() { this.sc = (this.sc + 1) % 3; this.ack = false; this.hr = this.sc === 1 ? 108 : 84 }

  @Builder lab(t: string) { Text(t).fontSize(14).fontColor('#9FB6BD') }

  build() {
    Swiper() {
      // 1 综合风险指数（示例评分）
      Column({ space: 6 }) {
        Stack() {
          Progress({ value: this.risk[this.sc], total: 100, type: ProgressType.Ring })
            .width(130).height(130).color(this.sc === 1 ? '#F2B84B' : '#41E0C2').style({ strokeWidth: 10 })
          Text(`${this.risk[this.sc]}`).fontSize(34).fontColor(Color.White).fontWeight(FontWeight.Bold)
        }
        this.lab('综合风险指数 · 示例')
        this.lab(`情景：${this.names[this.sc]}`)
        Button('切换情景').height(44).backgroundColor('#0B7A8C').onClick(() => this.next())
      }.justifyContent(FlexAlign.Center).width('100%').height('100%')

      // 2 生理信号（信号丢失时显示未知，不当作正常）
      Column({ space: 4 }) {
        this.lab('心率')
        Text(this.sc === 2 ? '--' : `${this.hr}`).fontSize(54).fontColor(Color.White).fontWeight(FontWeight.Bold)
        this.lab(this.sc === 2 ? '信号未知' : 'bpm')
        Row({ space: 28 }) {
          Column() { Text(this.sc === 2 ? '--' : (this.sc === 1 ? '37.6' : '36.4')).fontSize(22).fontColor(Color.White); this.lab('皮温°C') }
          Column() { Text('—').fontSize(22).fontColor(Color.White); this.lab('血压 未校准') }
        }
      }.justifyContent(FlexAlign.Center).width('100%').height('100%')

      // 3 人工复核
      Column({ space: 6 }) {
        Text(this.ack ? '已提交' : (this.sc === 0 ? '0' : '1')).fontSize(46).fontColor('#F2B84B').fontWeight(FontWeight.Bold)
        this.lab(this.sc === 0 ? '暂无待复核提示' : '条提示待人工复核')
        this.lab('仅提示，不作诊断')
        if (this.sc !== 0 && !this.ack) {
          Button('提交复核').height(44).backgroundColor('#0B7A8C').onClick(() => { this.ack = true })
        }
      }.justifyContent(FlexAlign.Center).width('100%').height('100%')
    }
    .indicator(true).loop(true).backgroundColor(Color.Black).width('100%').height('100%')
  }
}
