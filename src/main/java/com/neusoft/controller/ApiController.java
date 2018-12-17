package com.neusoft.controller;

import com.alibaba.fastjson.JSON;
import com.neusoft.domain.Comment;
import com.neusoft.domain.Topic;
import com.neusoft.domain.User;
import com.neusoft.domain.UserCommentAgree;
import com.neusoft.mapper.CommentMapper;
import com.neusoft.mapper.TopicMapper;
import com.neusoft.mapper.UserCommentAgreeMapper;
import com.neusoft.mapper.UserMapper;
import com.neusoft.response.RegRespObj;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("api")
public class ApiController {
    @Autowired
    TopicMapper topicMapper;
    @Autowired
    CommentMapper commentMapper;
    @Autowired
    UserCommentAgreeMapper userCommentAgreeMapper;
    @Autowired
    UserMapper userMapper;
    @RequestMapping("upload")
    @ResponseBody
    public RegRespObj upload (@RequestParam MultipartFile file,HttpServletRequest request) throws IOException {
        RegRespObj regRespObj = new RegRespObj();
        if (file.getSize()>0){
            String realPath = request.getServletContext().getRealPath("/res/uploadImgs");
            File file1 = new File(realPath);
            if(!file1.exists()){
                file1.mkdirs();
            }
            UUID uuid = UUID.randomUUID();
            File file2 = new File(realPath+File.separator+uuid+file.getOriginalFilename());
            file.transferTo(file2);
            HttpSession session = request.getSession();
            User userinfo = (User)session.getAttribute("userinfo");
            userinfo.setPicPath(uuid+file.getOriginalFilename());
            session.setAttribute("userinfo",userinfo);
            regRespObj.setUrl(request.getServletContext().getContextPath()+"/res/uploadImgs/"+uuid+file.getOriginalFilename());
            regRespObj.setStatus(0);
        }
        else
        {
            regRespObj.setStatus(1);
        }
        return regRespObj;
        }
    @RequestMapping("jie-set")
    public void jieSet (Integer id, Integer rank, String field, HttpServletResponse response) throws IOException {
        Topic topic = topicMapper.selectByPrimaryKey(id);
        if(field.equals("stick"))
        {
            topic.setIsTop(rank);
        }
        else if(field.equals("status"))
        {
            topic.setIsGood(rank);
        }
        topicMapper.updateByPrimaryKeySelective(topic);
        RegRespObj regRespObj = new RegRespObj();
        regRespObj.setStatus(0);
        response.getWriter().println(JSON.toJSONString(regRespObj));
    }
    @RequestMapping("jieda-zan")
    public void jiedaZan(Integer id, Boolean ok, HttpServletResponse response, HttpServletRequest request) throws IOException {
        RegRespObj regRespObj = new RegRespObj();
        HttpSession httpSession = request.getSession();
        User user = (User)httpSession.getAttribute("userinfo");
        if(user != null)
        {
            if(ok == false)//点赞
            {
                //当前评论的likenum++
                //在tab_user_comment_agree添加一条相应的记录
                Comment comment = commentMapper.selectByPrimaryKey(id);
                comment.setLikeNum(comment.getLikeNum() + 1);
                commentMapper.updateByPrimaryKeySelective(comment);
                //在tab_user_comment_agree添加一条相应的记录
                UserCommentAgree userCommentAgree = new UserCommentAgree();
                userCommentAgree.setCommentid(id);
                userCommentAgree.setUserid(user.getId());
                userCommentAgreeMapper.insertSelective(userCommentAgree);

            }
            else//取消点赞
            {
                //当前评论的likenum--
                //在tab_user_comment_agree删除一条相应的记录
                Comment comment = commentMapper.selectByPrimaryKey(id);
                comment.setLikeNum(comment.getLikeNum() - 1);
                commentMapper.updateByPrimaryKeySelective(comment);
                //在tab_user_comment_agree删除一条相应的记录
                Map<String,Object> map = new HashMap<>();
                map.put("userid",user.getId());
                map.put("commentid",id);
                userCommentAgreeMapper.deleteByUserIDAndCommentID(map);

            }
        }
        else
        {
            regRespObj.setStatus(1);
            regRespObj.setMsg("未登录");
        }
        response.getWriter().println(JSON.toJSONString(regRespObj));
    }

    @RequestMapping("jieda-accept")
    public void jiedaAccept(Integer id,HttpServletResponse response) throws IOException {
        RegRespObj regRespObj = new RegRespObj();
        regRespObj.setStatus(0);
        //评论记录的Is_Choose变成1
        Comment comment = commentMapper.selectByPrimaryKey(id);
        comment.setIsChoose(1);
        commentMapper.updateByPrimaryKeySelective(comment);
        //评论所在的topic的is_end变成1
        Topic topic = topicMapper.selectByPrimaryKey(comment.getTopicId());
        topic.setIsEnd(1);
        topicMapper.updateByPrimaryKeySelective(topic);
        User user = userMapper.selectByPrimaryKey(comment.getUserId());
        user.setKissNum(user.getKissNum() + topic.getKissNum());
        userMapper.updateByPrimaryKeySelective(user);
        response.getWriter().println(JSON.toJSONString(regRespObj));
    }
}
