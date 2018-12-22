<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/12/11
  Time: 14:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>用户主页</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="keywords" content="fly,layui,前端社区">
    <meta name="description" content="Fly社区是模块化前端UI框架Layui的官网社区，致力于为web开发提供强劲动力">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/res/layui/css/layui.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/res/css/global.css">
</head>
<body style="margin-top: 65px;">

<%@include file="../common/header.jsp"%>


<div class="fly-home fly-panel" style="background-image: url();">
    <img src="${pageContext.request.contextPath}/res/uploadImgs/${user.picPath}" alt=" ${user.nickname}">
    <i class="iconfont icon-renzheng" title="Fly社区认证"></i>
    <h1>
        ${user.nickname}
        <c:choose>
            <c:when test="${user.sex==0}">
                <i class="iconfont icon-nan"></i>
            </c:when>
            <c:otherwise>
                <i class="iconfont icon-nv"></i>
            </c:otherwise>
        </c:choose>
        <i class="layui-badge fly-badge-vip">VIP${user.vipGrade}</i>
        <!--
        <span style="color:#c00;">（管理员）</span>
        <span style="color:#5FB878;">（社区之光）</span>
        <span>（该号已被封）</span>
        -->
    </h1>

    <p style="padding: 10px 0; color: #5FB878;">认证信息：layui 作者</p>

    <p class="fly-home-info">
        <i class="iconfont icon-kiss" title="飞吻"></i><span style="color: #FF7200;">${user.kissNum} 飞吻</span>
        <i class="iconfont icon-shijian"></i><span><fmt:formatDate value="${user.joinTime}" pattern="yyyy-MM-dd"/> 加入</span>
        <i class="iconfont icon-chengshi"></i><span>来自${user.city}</span>
    </p>

    <p class="fly-home-sign">${user.sign}</p>

    <%--<div class="fly-sns" data-user="">--%>
        <%--<a href="javascript:;" class="layui-btn layui-btn-primary fly-imActive" data-type="addFriend">加为好友</a>--%>
        <%--<a href="javascript:;" class="layui-btn layui-btn-normal fly-imActive" data-type="chat">发起会话</a>--%>
    <%--</div>--%>

</div>

<div class="layui-container">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md6 fly-home-jie">
            <div class="fly-panel">
                <h3 class="fly-panel-title">${user.nickname} 最近的提问</h3>
                <ul class="jie-row">
                    <c:forEach items="${userList}" var="userlist">
                    <li>
                        <c:if test="${userlist.is_good ==1}">
                        <span class="fly-jing">精</span>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/jie/detail/${userlist.topicid}" class="jie-title"> ${userlist.title}</a>
                        <i>${userlist.create_time}</i>
                        <em class="layui-hide-xs">${userlist.view_times}阅/${userlist.comment_num}答</em>
                        <input type="hidden" name="userlist.topicid" value="${userlist.topicid}" >
                    </li>
                    </c:forEach>
                    <c:if test="${empty userList}">
                     <div class="fly-none" style="min-height: 50px; padding:30px 0; height:auto;"><i style="font-size:14px;">没有发表任何求解</i></div> -->
                    </c:if>
                </ul>
            </div>
        </div>

        <div class="layui-col-md6 fly-home-da">
            <div class="fly-panel">
                <h3 class="fly-panel-title">${user.nickname} 最近的回答</h3>
                <ul class="home-jieda">
                    <c:forEach items="${userList2}" var="userlist2">
                    <li>
                        <p>
                            <span>${userlist2.comment_time}</span>
                            在<a href="${pageContext.request.contextPath}/jie/detail/ ${userlist2.id}" target="_blank">${userlist2.title}</a>中回答：
                        </p>
                        <div class="home-dacontent">
                            <%--<pre>--%>
                                    ${userlist2.comment_content}
                            <%--</pre>--%>
                        </div>
                    </li>
                    </c:forEach>
                    <c:if test="${empty userList2 }">
                     <div class="fly-none" style="min-height: 50px; padding:30px 0; height:auto;"><span>没有回答任何问题</span></div>
                    </c:if>
                </ul>
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
    <%@include file="../common/cache_user.jsp"%>
    layui.config({
        version: "3.0.0"
        ,base: '${pageContext.request.contextPath}/res/mods/'
    }).extend({
        fly: 'index'
    }).use(['fly', 'face'],function () {
        var $ = layui.$
            ,fly = layui.fly;
        $('.home-dacontent').each(function(){
            var othis = $(this);
            var html = othis.html();
            var content = fly.content(html);
            othis.html(content);
        });
    });
</script>

</body>
</html>
