package com.dn.sports.adcoinLogin.model;


import java.util.Date;


public class User {
    private int id;//数据库ID
    private String code;//微信code
    private String userId;//用户ID
    private String mobile;//手机号码
    private String password;//密码
    private String nickname;//昵称
    private String manufacturer;//厂商
    private String sdkVersion;//android api level
    private String phoneType;//手机型号
    private int sex;//性别
    private String birthday;//生日
    private String address;//个人地址
    private String channel;//渠道
    public int stepTarget;//目标步数
    private String headImg;//头像
    private int loginType;//登陆方式   0 微信
    private String tips;//简介
    private int hasSign;//是否已签到  1 已签到   0 未签到
    private float balance;//余额(金币)
    private float total_mount;//总收益
    private int inviteCount;//邀请好友的次数
    private int continueSyncStepTarget;//连续同步达到6000步的天数
    private Date lastSyncTime;//最后同步步数的时间
    private String beInviteCode;//邀请自己的人
    private String inviteCode;//邀请码
    private int isSignIn;//是否第三方登陆  1 是    0  否
    private int continueSign;//连续签到天数
    private int totalSign;//总签到天数
    private Date lastLoginTime;//最后登陆时间
    private int isActive;//是否是活跃用户(连续7天不登陆活跃消失) 1 活跃    0 不活跃
    private Date createTime;//创建时间
    private int lastSyncStep;

    public int getLastSyncStep() {
        return lastSyncStep;
    }

    public void setLastSyncStep(int lastSyncStep) {
        this.lastSyncStep = lastSyncStep;
    }

    public User() {
        isActive = 1;
    }

    public int getIsActive() {
        return isActive;
    }

    public void setIsActive(int isActive) {
        this.isActive = isActive;
    }

    public Date getLastSyncTime() {
        return lastSyncTime;
    }

    public void setLastSyncTime(Date lastSyncTime) {
        this.lastSyncTime = lastSyncTime;
    }

    public int getContinueSyncStepTarget() {
        return continueSyncStepTarget;
    }

    public void setContinueSyncStepTarget(int continueSyncStepTarget) {
        this.continueSyncStepTarget = continueSyncStepTarget;
    }

    public Date getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(Date lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    public int getInviteCount() {
        return inviteCount;
    }

    public void setInviteCount(int inviteCount) {
        this.inviteCount = inviteCount;
    }

    public int getStepTarget() {
        return stepTarget;
    }

    public void setStepTarget(int stepTarget) {
        this.stepTarget = stepTarget;
    }

    public String getBeInviteCode() {
        return beInviteCode;
    }

    public void setBeInviteCode(String beInviteCode) {
        this.beInviteCode = beInviteCode;
    }

    public String getInviteCode() {
        return inviteCode;
    }

    public void setInviteCode(String inviteCode) {
        this.inviteCode = inviteCode;
    }

    public int getIsSignIn() {
        return isSignIn;
    }

    public void setIsSignIn(int isSignIn) {
        this.isSignIn = isSignIn;
    }

    public int getHasSign() {
        return hasSign;
    }

    public void setHasSign(int hasSign) {
        this.hasSign = hasSign;
    }


    public float getBalance() {
        return balance;
    }

    public void setBalance(float balance) {
        this.balance = balance;
    }

    public float getTotal_mount() {
        return total_mount;
    }

    public void setTotal_mount(float total_mount) {
        this.total_mount = total_mount;
    }

    public String getTips() {
        return tips;
    }

    public void setTips(String tips) {
        this.tips = tips;
    }

    public int getLoginType() {
        return loginType;
    }

    public void setLoginType(int loginType) {
        this.loginType = loginType;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public void setSex(int sex) {
        this.sex = sex;
    }


    public int getContinueSign() {
        return continueSign;
    }

    public void setContinueSign(int continueSign) {
        this.continueSign = continueSign;
    }

    public int getTotalSign() {
        return totalSign;
    }

    public void setTotalSign(int totalSign) {
        this.totalSign = totalSign;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getHeadImg() {
        return headImg;
    }

    public void setHeadImg(String headImg) {
        this.headImg = headImg;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getSdkVersion() {
        return sdkVersion;
    }

    public void setSdkVersion(String sdkVersion) {
        this.sdkVersion = sdkVersion;
    }

    public String getPhoneType() {
        return phoneType;
    }

    public void setPhoneType(String phoneType) {
        this.phoneType = phoneType;
    }

    public int getSex() {
        return sex;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Override
    public String toString() {
        return "userId:"+userId+"\n"
                +"headImg:"+headImg+"\n"
                +"nickname:"+nickname+"\n"
                +"hasSign:"+hasSign+"\n"
                +"total_mount:"+total_mount+"\n"
                +"createTime:"+createTime+"\n"
                +"lastLoginTime:"+lastLoginTime+"\n"
                +"lastSyncTime:"+lastSyncTime+"\n";
    }
}
