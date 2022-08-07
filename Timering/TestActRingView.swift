//
//  TestActRingView.swift
//  Timering
//
//  Created by 竹内響汰 on 2022/08/01.
//
import SwiftUI
extension Color {
    static let color = Color("Color")
}

//2022/08/07    現状：内部で目標時間、作業時間を設定して動作することを確認
//              今後やること：３つのカテゴリーを設定するためのポップアップ
//              目標時間を決める関数、作業時間を外部から引っ張ってくる

class pCircle:ObservableObject {
    //@Published var toPercNow: Double
    
    //@Published var percNow_1: Double
    //@Published var percNow_2: Double
    //@Published var percNow_3: Double
    
    let setSize_1: CGFloat
    let setSize_2: CGFloat
    let setSize_3: CGFloat
    
    //@Published var circlePosition: String

    init(){
        //self.percNow = percNow
        //self.setSize = setSize
        //self.setColor = setColor
        //self.toPercNow = toPercNow
        
        //self.percNow_1 = percNow_1
        //self.percNow_2 = percNow_2
        //self.percNow_3 = percNow_3
        
        self.setSize_1 = 100
        self.setSize_2 = 160
        self.setSize_3 = 220
        
        //self.circlePosition = circlePosition
    }
    
    func printCircle(circlePosition: String) -> (setSize: Double, setColor: String){
        //var percNow: Double
        var setSize:CGFloat = 0
        var setColor: String = "Blue"
        
        //percNow = round(toPercNow)
        
        if(circlePosition=="in"){
            setSize = setSize_1
            setColor = "Blue"
        }else if(circlePosition=="center"){
            setSize = setSize_2
            setColor = "Purple"
        }else if(circlePosition=="out"){
            setSize = setSize_3
            setColor = "Green"
        }
        
        return (setSize, setColor)
    }
}

class ringIn: ObservableObject{
    @Published var c1_category:String
    @Published var c1_perc:Double
    @Published var c1_goal:Double
    var c1_now:Double
    let c1_position:String
    
    init(c1_category:String, c1_goal: Double, c1_now: Double){
        self.c1_category = c1_category
        self.c1_goal = c1_goal
        self.c1_now = c1_now
        self.c1_perc = c1_now / c1_goal
        self.c1_position = "in"
    }
    
    func setTimeGoal() -> Double{
        //未完成
        return c1_perc
    }
    
    func tellAchive(){
        //未完成
        //Text("\(c1_category)の目標を達成しました.")
    }
    
    func getTimeLog(){
        //未完成
    }
}

class ringCenter: ObservableObject{
    @Published var c2_category:String
    @Published var c2_perc:Double
    @Published var c2_goal:Double
    var c2_now:Double
    let c2_position:String
    
    init(c2_category:String, c2_goal: Double, c2_now: Double){
        self.c2_category = c2_category
        self.c2_goal = c2_goal
        self.c2_now = c2_now
        self.c2_perc = c2_now / c2_goal
        self.c2_position = "center"
    }
    
    func setTimeGoal() -> Double{
        //未完成
        return c2_perc
    }
    
    func tellAchive(){
        //未完成
        //Text("\(c1_category)の目標を達成しました.")
    }
    
    func getTimeLog(){
        //未完成
    }
    
}

class ringOut: ObservableObject{
    @Published var c3_category:String
    @Published var c3_perc:Double
    @Published var c3_goal:Double
    var c3_now:Double
    let c3_position:String
    
    init(c3_category:String, c3_goal: Double, c3_now: Double){
        self.c3_category = c3_category
        self.c3_goal = c3_goal
        self.c3_now = c3_now
        self.c3_perc = c3_now / c3_goal
        self.c3_position = "out"
    }
    
    func setTimeGoal() -> Double{
        //未完成
        return c3_perc
    }
    
    func tellAchive(){
        //未完成
        //Text("\(c1_category)の目標を達成しました.")
    }
    
    func getTimeLog(){
        //未完成
    }
    
}

class setActRing: ObservableObject{
    func selectCategory(){
        //未完成
        //引数：ポジション1,2,3の使用フラグ　戻り値：ポジション1,2,3の使用カテゴリー
        //カテゴリー, 全作業時間, 休憩時間, 作業時間, ポジション
    }
}

struct TestActRingView: View {
    let col = ":"
    //インスタンス化//初期化時にインスタンス変数がダメ→今は直いれ→要修正
    //~_nowにどこかのviewから作業時間引っ張ってくる
    var drawCircle = pCircle()
    var c1 = ringIn(c1_category: "Study", c1_goal: 9, c1_now: 5)
    var c2 = ringCenter(c2_category: "Work", c2_goal: 20, c2_now: 5)
    var c3 = ringOut(c3_category: "Reading", c3_goal: 100, c3_now: 8)
    
    
    var body: some View {
        let SizeColor_1 = drawCircle.printCircle(circlePosition: "in")
        let SizeColor_2 = drawCircle.printCircle(circlePosition: "center")
        let SizeColor_3 = drawCircle.printCircle(circlePosition: "out")
        
        let percIn = (c1.c1_perc)*100.rounded()
        let percCenter = (c2.c2_perc)*100.rounded()
        let percOut = (c3.c3_perc)*100.rounded()
  
        VStack(alignment : .center){
            Text(Date(),style: .date)
                .font(.system(size: 30, weight: .thin, design: .default))
                .multilineTextAlignment(.center)
                .padding(.vertical, 50.0)
                .offset(y: -80)
            
            ZStack(){
                
                Circle()
                    .trim(from: 0, to: c1.c1_perc)    //from ~ toと変数の%を対応させる。
                    .stroke(Color(SizeColor_1.1), style: StrokeStyle(lineWidth: 10))
                    .frame(width: SizeColor_1.0, height: SizeColor_1.0)
                    .rotationEffect(Angle(degrees: -90))
                
                Circle()
                    .trim(from: 0, to: c2.c2_perc)    //from ~ toと変数の%を対応させる。
                    .stroke(Color(SizeColor_2.1), style: StrokeStyle(lineWidth: 10))
                    .frame(width: SizeColor_2.0, height: SizeColor_2.0)
                    .rotationEffect(Angle(degrees: -90))
                
                Circle()
                    .trim(from: 0, to: c3.c3_perc)    //from ~ toと変数の%を対応させる。
                    .stroke(Color(SizeColor_3.1), style: StrokeStyle(lineWidth: 10))
                    .frame(width: SizeColor_3.0, height: SizeColor_3.0)
                    .rotationEffect(Angle(degrees: -90))
                
                

            }.offset(y: -80)
            
            VStack(spacing: 20){//colonがずれるのなんとかしたい。
                HStack(alignment: .center, spacing: 80){
                    Text("\(c1.c1_category)")
                        .multilineTextAlignment(.leading)
                    Text("\(col)")
                    Text("\(String(format: "%.1f", percIn)) %")
                }
                
                Divider()
                
                HStack(alignment: .center, spacing: 80){
                    Text("\(c2.c2_category)")
                        .multilineTextAlignment(.leading)
                    Text("\(col)")
                    Text("\(String(format: "%.1f", percCenter)) %")
                }
                
                Divider()
                
                HStack(alignment: .center, spacing: 80){
                    Text("\(c3.c3_category)")
                        .multilineTextAlignment(.leading)
                    Text("\(col)")
                    Text("\(String(format: "%.1f", percOut)) %")
                }
                
                Divider()
            }

        }
            }
}


struct TestActRingView_Previews: PreviewProvider {
    static var previews: some View {
        TestActRingView()
    }
}
