<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/12/10
  Time: 15:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>${topic.title}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="keywords" content="fly,layui,前端社区">
    <meta name="description" content="Fly社区是模块化前端UI框架Layui的官网社区，致力于为web开发提供强劲动力">
    <link rel="stylesheet" href="../../res/layui/css/layui.css">
    <link rel="stylesheet" href="../../res/css/global.css">
</head>
<body>

<%@include file="../common/header.jsp"%>
<%@include file="../common/column.jsp"%>

<div class="layui-container">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md8 content detail">
            <div class="fly-panel detail-box">
                <h1>${topic.title}</h1>
                <div class="fly-detail-info">
                    <!-- <span class="layui-badge">审核中</span> -->
                    <span class="layui-badge layui-bg-green fly-detail-column">${topic.name}</span>

                    <span class="layui-badge" style="background-color: #999;">未结</span>
                    <!-- <span class="layui-badge" style="background-color: #5FB878;">已结</span> -->
                    <c:if test="${topic.is_top == 1}">
                        <span class="layui-badge layui-bg-black">置顶</span>
                    </c:if>
                    <c:if test="${topic.is_good == 1}">
                        <span class="layui-badge layui-bg-red">精帖</span>
                    </c:if>
                    <c:if test="${userinfo.isadmin == 1}">
                        <div class="fly-admin-box" data-id="${topic.topic_id}">
                            <span class="layui-btn layui-btn-xs jie-admin" type="del">删除</span>
                            <c:choose>
                                <c:when test="${topic.is_top == 0}">
                                    <span class="layui-btn layui-btn-xs jie-admin" type="set" field="stick" rank="1">置顶</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="layui-btn layui-btn-xs jie-admin" type="set" field="stick" rank="0" style="background-color:#ccc;">取消置顶</span>
                                </c:otherwise>
                            </c:choose>
                            <c:choose>
                                <c:when test="${topic.is_good == 0}">
                                    <span class="layui-btn layui-btn-xs jie-admin" type="set" field="status" rank="1">加精</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="layui-btn layui-btn-xs jie-admin" type="set" field="status" rank="0" style="background-color:#ccc;">取消加精</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <span class="fly-list-nums">
            <a href="#comment"><i class="iconfont" title="回答">&#xe60c;</i> ${topic.comment_num}</a>
            <i class="iconfont" title="人气">&#xe60b;</i> 99999
          </span>
                </div>
                <div class="detail-about">
                    <a class="fly-avatar" href="../user/home.html">
                        <c:choose>
                            <c:when test="${topic.pic_path != ''}">
                                <img src="${pageContext.request.contextPath}/res/uploadImgs/${topic.pic_path}" alt="${topic.nickname}">
                            </c:when>
                            <c:otherwise>
                                <img src="https://tva1.sinaimg.cn/crop.0.0.118.118.180/5db11ff4gw1e77d3nqrv8j203b03cweg.jpg">
                            </c:otherwise>
                        </c:choose>
                    </a>
                    <div class="fly-detail-user">
                        <a href="../user/home.html" class="fly-link">
                            <cite>${topic.nickname}</cite>
                            <i class="iconfont icon-renzheng" title="认证信息：{{ rows.user.approve }}"></i>
                            <i class="layui-badge fly-badge-vip">VIP3</i>
                        </a>
                        <span>${topic.create_time}</span>
                    </div>
                    <div class="detail-hits" id="LAY_jieAdmin" data-id="123">
                        <span style="padding-right: 10px; color: #FF7200">悬赏：${topic.kiss_num}飞吻</span>
                        <c:if test="${!empty userinfo}">
                            <c:if test="${userinfo.id == topic.userid}">
                                <span class="layui-btn layui-btn-xs jie-admin" type="edit"><a href="add.html">编辑此贴</a></span>
                            </c:if>
                        </c:if>

                    </div>
                </div>
                <div class="detail-body photos">
                    ${topic.content}
                </div>
            </div>

            <div class="fly-panel detail-box" id="flyReply">
                <fieldset class="layui-elem-field layui-field-title" style="text-align: center;">
                    <legend>回帖</legend>
                </fieldset>

                <ul class="jieda" id="jieda">

                    <c:forEach items="${comments}" var="comment">
                        <li data-id="111" class="jieda-daan">
                            <a name="item-1111111111"></a>
                            <div class="detail-about detail-about-reply">
                                <a class="fly-avatar" href="#">
                                    <img src="${pageContext.request.contextPath}/res/uploadImgs/${comment.pic_path}" alt="${comment.nickname}">
                                </a>
                                <div class="fly-detail-user">
                                    <a href="#" class="fly-link">
                                        <cite>${comment.nickname}</cite>
                                        <i class="iconfont icon-renzheng" title="认证信息：XXX"></i>
                                        <i class="layui-badge fly-badge-vip">VIP${comment.vip_grade}</i>
                                    </a>

                                    <c:if test="${topic.userid == comment.userid}">
                                        <span>(楼主)</span>
                                    </c:if>

                                    <!--
                                    <span style="color:#5FB878">(管理员)</span>
                                    <span style="color:#FF9E3F">（社区之光）</span>
                                    <span style="color:#999">（该号已被封）</span>
                                    -->
                                </div>

                                <div class="detail-hits">
                                    <span>${comment.comment_time}</span>
                                </div>

                                <i class="iconfont icon-caina" title="最佳答案"></i>
                            </div>
                            <div class="detail-body jieda-body photos">
                                    ${comment.comment_content}
                            </div>
                            <div class="jieda-reply">
              <span class="jieda-zan zanok" type="zan">
                <i class="iconfont icon-zan"></i>
                <em>${comment.like_num}</em>
              </span>
                                <span type="reply">
                <i class="iconfont icon-svgmoban53"></i>
                回复
              </span>
                                <div class="jieda-admin">
                                    <span type="edit">编辑</span>
                                    <span type="del">删除</span>
                                    <!-- <span class="jieda-accept" type="accept">采纳</span> -->
                                </div>
                            </div>
                        </li>
                    </c:forEach>




                    <!-- 无数据时 -->
                    <!-- <li class="fly-none">消灭零回复</li> -->
                </ul>

                <div class="layui-form layui-form-pane">
                    <form action="${pageContext.request.contextPath}/jie/reply/" method="post">
                        <div class="layui-form-item layui-form-text">
                            <a name="comment"></a>
                            <div class="layui-input-block">
                                <textarea id="L_content" name="content" required lay-verify="required" placeholder="请输入内容"  class="layui-textarea fly-editor" style="height: 150px;"></textarea>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <input type="hidden" name="topicId" value="${topic.topic_id}">
                            <button class="layui-btn" lay-filter="*" lay-submit>提交回复</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="layui-col-md4">
            <dl class="fly-panel fly-list-one">
                <dt class="fly-panel-title">本周热议</dt>
                <dd>
                    <a href="">基于 layui 的极简社区页面模版</a>
                    <span><i class="iconfont icon-pinglun1"></i> 16</span>
                </dd>
                <dd>
                    <a href="">基于 layui 的极简社区页面模版</a>
                    <span><i class="iconfont icon-pinglun1"></i> 16</span>
                </dd>
                <dd>
                    <a href="">基于 layui 的极简社区页面模版</a>
                    <span><i class="iconfont icon-pinglun1"></i> 16</span>
                </dd>
                <dd>
                    <a href="">基于 layui 的极简社区页面模版</a>
                    <span><i class="iconfont icon-pinglun1"></i> 16</span>
                </dd>
                <dd>
                    <a href="">基于 layui 的极简社区页面模版</a>
                    <span><i class="iconfont icon-pinglun1"></i> 16</span>
                </dd>
                <dd>
                    <a href="">基于 layui 的极简社区页面模版</a>
                    <span><i class="iconfont icon-pinglun1"></i> 16</span>
                </dd>
                <dd>
                    <a href="">基于 layui 的极简社区页面模版</a>
                    <span><i class="iconfont icon-pinglun1"></i> 16</span>
                </dd>
                <dd>
                    <a href="">基于 layui 的极简社区页面模版</a>
                    <span><i class="iconfont icon-pinglun1"></i> 16</span>
                </dd>
                <dd>
                    <a href="">基于 layui 的极简社区页面模版</a>
                    <span><i class="iconfont icon-pinglun1"></i> 16</span>
                </dd>
                <dd>
                    <a href="">基于 layui 的极简社区页面模版</a>
                    <span><i class="iconfont icon-pinglun1"></i> 16</span>
                </dd>

                <!-- 无数据时 -->
                <!--
                <div class="fly-none">没有相关数据</div>
                -->
            </dl>

            <div class="fly-panel">
                <div class="fly-panel-title">
                    这里可作为广告区域
                </div>
                <div class="fly-panel-main">
                    <a href="http://layim.layui.com/?from=fly" target="_blank" class="fly-zanzhu" time-limit="2017.09.25-2099.01.01" style="background-color: #5FB878;">LayIM 3.0 - layui 旗舰之作</a>
                </div>
            </div>

            <div class="fly-panel" style="padding: 20px 0; text-align: center;">
                <img src="../../res/images/weixin.jpg" style="max-width: 100%;" alt="layui">
                <p style="position: relative; color: #666;">微信扫码关注 layui 公众号</p>
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

<script src="../../res/layui/layui.js"></script>
<script>
    layui.cache.page = 'jie';
    <c:choose>
    <c:when test="${!empty userinfo}">
    layui.cache.user = {
        username: '${userinfo.nickname}'
        ,uid: ${userinfo.id}
        ,avatar: '${pageContext.request.contextPath}/res/uploadImgs/${userinfo.picPath}'
        ,experience: 83
        ,sex: '男'
    };
    </c:when>
     <c:otherwise>
    layui.cache.user = {
        username: '游客'
        ,uid: -1
        ,avatar: '../../res/images/avatar/00.jpg'
        ,experience: 83
        ,sex: '男'
    };
    </c:otherwise>
    </c:choose>

    layui.config({
        version: "3.0.0"
        ,base: '../../res/mods/'
    }).extend({
        fly: 'index'
    }).use(['fly', 'face'], function(){
        var $ = layui.$
            ,fly = layui.fly;
        //如果你是采用模版自带的编辑器，你需要开启以下语句来解析。

         $('.detail-body').each(function(){
         var othis = $(this), html = othis.html();
         othis.html(fly.content(html));
         });

    });
</script>

</body>
</html>
