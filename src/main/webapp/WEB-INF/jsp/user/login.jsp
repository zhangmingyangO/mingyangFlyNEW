<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/12/6
  Time: 16:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>登入</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="keywords" content="fly,layui,前端社区">
    <meta name="description" content="Fly社区是模块化前端UI框架Layui的官网社区，致力于为web开发提供强劲动力">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/res/layui/css/layui.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/res/css/global.css">

</head>
<script src="${pageContext.request.contextPath}/res/mods/util.js"></script>
<script src=" ${pageContext.request.contextPath}/res/jquery-3.3.1.js"></script>
<script>
    var result=0;
    $(function () {
        var firstNum=Math.floor(Math.random()*20)+1;
        var SecondNum=Math.floor(Math.random()*20)+1;
        result=firstNum+SecondNum;
        $("#spanRenlei").text(firstNum+"+"+SecondNum+"=?");
    });
    $(function () {
        $("#L_vercode").blur(function () {
            if($("#L_vercode").val() != result){
                $("#checkRenlei").text("答案错误");
            }else {
                $("#checkRenlei").text("");
            }
        })
    });
    $(function () {
        $("button[class=layui-btn]").click(function () {
            if($("#checkRenlei").text() == "答案错误"){
                alert("答案错误,重新回答");
                return false;
            }
            var  str = $('#form1').text().val()
            alert(str)
            if (str.length>0) {
                alert("注册成功")
            }
        })

    })
</script>
<body>

<%@include file="../common/header.jsp"%>

<div class="layui-container fly-marginTop">
    <div class="fly-panel fly-panel-user" pad20>
        <div class="layui-tab layui-tab-brief" lay-filter="user">
            <ul class="layui-tab-title">
                <li class="layui-this">登入</li>
                <li><a href="reg.html">注册</a></li>
            </ul>
            <div class="layui-form layui-tab-content" id="LAY_ucm" style="padding: 20px 0;">
                <div class="layui-tab-item layui-show">
                    <div class="layui-form layui-form-pane">
                        <form method="post" action="${pageContext.request.contextPath}/user/dologin">
                            <div class="layui-form-item">
                                <label for="L_email" class="layui-form-label">邮箱</label>
                                <div class="layui-input-inline">
                                    <input type="text" id="L_email" name="email" required lay-verify="required" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-form-item">
                                <label for="L_pass" class="layui-form-label">密码</label>
                                <div class="layui-input-inline">
                                    <input type="password" id="L_pass" name="passwd" required lay-verify="required" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-form-item">
                                <label for="L_vercode" class="layui-form-label">人类验证</label>
                                <div class="layui-input-inline">
                                    <input type="text" id="L_vercode" name="vercode" required lay-verify="required" placeholder="请回答后面的问题" autocomplete="off" class="layui-input">
                                    <span id="checkRenlei"></span>
                                </div>
                                <div class="layui-form-mid">
                                    <span style="color: #c00;" id="spanRenlei"></span>
                                </div>
                            </div>
                            <div class="layui-form-item">
                                <button class="layui-btn" lay-filter="*" lay-submit>立即登录</button>
                                <span style="padding-left:20px;">
                  <a href="forget.html">忘记密码？</a>
                </span>
                            </div>
                            <div class="layui-form-item fly-form-app">
                                <span>或者使用社交账号登入</span>
                                <a href="" onclick="layer.msg('正在通过QQ登入', {icon:16, shade: 0.1, time:0})" class="iconfont icon-qq" title="QQ登入"></a>
                                <a href="" onclick="layer.msg('正在通过微博登入', {icon:16, shade: 0.1, time:0})" class="iconfont icon-weibo" title="微博登入"></a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="fly-footer">
    <p><a href="http://fly.layui.com/" target="_blank">Fly社区</a> 2017 &copy; <a href="http://www.layui.com/" target="_blank">layui.com 出品</a></p>
    <p>
        <a href="http://fly.layui.com/jie/3147/" target="_blank">付费计划</a>
        <a href="http://www.layui.com/template/fly/" target="_blank">获取Fly社区模版</a>
        <a href="http://fly.layui.com/jie/2461/" target="_blank">微信公众号</a>
    </p>
</div>

<script src="${pageContext.request.contextPath}/res/layui/layui.js"></script>
<script>
    layui.cache.page = 'user';
    layui.cache.user = {
        username: '游客'
        ,uid: -1
        ,avatar: '../../res/images/avatar/00.jpg'
        ,experience: 83
        ,sex: '男'
    };
    layui.config({
        version: "3.0.0"
        ,base: '../../res/mods/'
    }).extend({
        fly: 'index'
    }).use('fly');
</script>

</body>
</html>
