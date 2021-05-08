int programStatue = 0;
public static int VideoChooseScene = 0; 
public static int Video_1_PlayScene = 1; 
public static int Video_2_PlayScene = 2; 
public static int Video_3_PlayScene = 3; 
public static int Video_1_ColorChangeScene = 4; 
public static int Video_2_ColorChangeScene = 5; 
public static int Video_3_ColorChangeScene = 6; 

public static int Command_Video_1_Cover = 1;
public static int Command_Video_2_Cover = 2;
public static int Command_Video_3_Cover = 3;
public static int Command_Video_1_Play = 4;
public static int Command_Video_2_Play = 5;
public static int Command_Video_3_Play = 6;
public static int Command_Video_1_ChangeColor = 7;
public static int Command_Video_2_ChangeColor = 8;
public static int Command_Video_3_ChangeColor = 9;

public static int HandShapBack = 0;
public static int HandShapStone = 1;
public static int HandShapSword = 2;
public static int HandShapBye = 3;

@define VideoChooseScene 0


void setup(){
    fullscreen();
}

void draw(){
    //无论如何都会刷新背景
    BackGroundScene();
    //这里检测控制信号，判断程序是否应该退出
    ControlCmdCheck();
    //一下代码制定了程序可能出现的7种情况，根据操作检测环节的返回值来确定该如何刷新界面
    if(programStatue == VideoChooseScene){

    }else if(programStatue == Video_1_PlayScene){
        
    }else if(programStatue == Video_2_PlayScene){
        
    }else if(programStatue == Video_3_PlayScene){
        
    }else if(programStatue == Video_1_ColorChangeScene){
        
    }else if(programStatue == Video_2_ColorChangeScene){
        
    }else if(programStatue == Video_3_ColorChangeScene){
        
    }
}

void BackGroundScene(){
    //这里刷新和显示背景的变化，其他内容都在此基础上刷新和显示
}

int ControlCmdCheck(){
    //检测手势并返回手势代码，每次返回值唯一
    //在这里应对手部突然抽出的情况

    //检测鼠标和键盘输入，检测退出按钮
}

void VideoChooseScene(){
    //发送循环屏幕指令和封面信息供客户端播放
    int HandX = 0;//检测手的位置
    
    //这里循环刷新和显示视频选择界面
}

void Video_1_PlayScene(){
    CommandSend(Command_Video_1_Play);
    //播放视频1
}

void Video_2_PlayScene(){
    CommandSend(Command_Video_2_Play);
    //播放视频2
}

void Video_3_PlayScene(){
    CommandSend(Command_Video_2_Play);
    //播放视频3
}

void Video_1_ColorChangeScene(){
    CommandSend(Command_Video_1_ChangeColor);
     Video_1_PlayScene();
     //后面写发送信息要求客户端播放视频1换色指令
}

void Video_2_ColorChangeScene(){
    CommandSend(Command_Video_2_ChangeColor);
    Video_2_PlayScene();
    //后面写发送信息要求客户端播放视频2换色指令
}

void Video_3_ColorChangeScene(){
    CommandSend(Command_Video_2_ChangeColor);
    Video_3_PlayScene();
    //后面写发送信息要求客户端播放视频3换色指令
}

void CommandSend(int CommandStateMant){
    //向客户端发送相应指令
}