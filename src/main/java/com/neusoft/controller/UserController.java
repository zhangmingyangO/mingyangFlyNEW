package com.neusoft.controller;

import com.neusoft.mapper.TopicMapper;
import com.neusoft.util.MD5Utils;
import com.neusoft.domain.User;
import com.neusoft.mapper.UserMapper;
import com.neusoft.response.RegRespObj;
import com.neusoft.util.StringDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Created by Administrator on 2018/12/6.
 */
@Controller
@RequestMapping("user")
public class UserController {

    @Autowired
    UserMapper userMapper;
    @Autowired
    TopicMapper topicMapper;
//    @RequestMapping("add/{tid}")
//    @ResponseBody
//    public ModelAndView add (){
//        ModelAndView modelAndView = new ModelAndView();
//
//        return modelAndView;
//    }
    @RequestMapping("message")
    public String message(){

        return "user/message";
    }
    @RequestMapping("index/{uid}")
    @ResponseBody
    public ModelAndView index( @PathVariable Integer uid,HttpServletRequest request){
        RegRespObj regRespObj = new RegRespObj();
        HttpSession session = request.getSession();
        String referer = (String) session.getAttribute("referer");
            if (uid < 0){
                regRespObj.setStatus(0);
                regRespObj.setAction(request.getServletContext().getContextPath() + "/user/login");
            }
        ModelAndView modelAndView = new ModelAndView();
        int count = userMapper.selectByTopicUserIdcount(uid);
        List<Map<String,Object>> mapList1 = userMapper.selectByTopicUserId(uid);
        System.out.println(count);
        modelAndView.addObject("uid",uid);
        modelAndView.addObject("userTopicCount",count);
        modelAndView.addObject("userTopic",mapList1);
        modelAndView.setViewName("user/index");
        return modelAndView;
    }
    @RequestMapping("upmessage")
    @ResponseBody
    public RegRespObj upmessage( HttpServletRequest request,User user){
        RegRespObj regRespObj = new RegRespObj();
        User user1 = userMapper.selectByEmail(user.getEmail());
        if (user1==null){
            HttpSession session = request.getSession();
            User userinfo = (User) request.getSession().getAttribute("userinfo");
            // User userinfo = (User) session.getAttribute("userinfo");
            user.setId(userinfo.getId());
            int i = userMapper.updateByPrimaryKeySelective(user);
            if (i>0){
                User user2 = userMapper.selectByPrimaryKey(user.getId());
                session.setAttribute("userinfo",user2);
                regRespObj.setStatus(0);
                regRespObj.setMsg("修改成功");
                regRespObj.setAction(request.getServletContext().getContextPath()+"/user/set");
            }else {
                regRespObj.setMsg("修改失败");
                regRespObj.setStatus(1);
            }
        }else {
            regRespObj.setMsg("修改失败,邮箱重复");
            regRespObj.setStatus(1);
        }

        return regRespObj;
    }
    @RequestMapping("modifyPWD")
    @ResponseBody
    public  RegRespObj repass(HttpServletRequest request,String pass){
        System.out.println("我恶趣味恶趣味企鹅企鹅11111111111111");
        RegRespObj regRespObj = new RegRespObj();
        HttpSession session = request.getSession();
        User userinfo = (User)session.getAttribute("userinfo");
        String pwd = MD5Utils.getPwd(pass);
        userinfo.setPasswd(pwd);
        userMapper.updateByPrimaryKeySelective(userinfo);
        regRespObj.setStatus(0);
        regRespObj.setAction("/user/set");

        return  regRespObj;
    }

    @RequestMapping("reg")
    public String reg()
    {
        return "user/reg";
    }

    @RequestMapping("doreg")
    @ResponseBody
    public RegRespObj doReg(User user, HttpServletRequest request)
    {
        RegRespObj regRespObj = new RegRespObj();
        User user1 = userMapper.selectByEmail(user.getEmail());
        if(user1==null){
            user.setKissNum(100);
            user.setJoinTime(new Date());
            String passwd = user.getPasswd();
            String pwd = MD5Utils.getPwd(passwd);
            user.setPasswd(pwd);
            int i = userMapper.insertSelective(user);
            if(i>0){
                regRespObj.setStatus(0);
                System.out.println(request.getServletContext().getContextPath());
                regRespObj.setAction(request.getServletContext().getContextPath() + "/");
            }else {
                regRespObj.setStatus(1);
                regRespObj.setMsg("数据库错误，联系管理员");
            }
        }else {
            regRespObj.setStatus(1);
            regRespObj.setMsg("邮箱重复，请换邮箱注册");
        }
        return regRespObj;

    }
    @RequestMapping("/checkEmail")
    @ResponseBody
    public RegRespObj checkEmail(User user){
        RegRespObj regRespObj = new RegRespObj();
        User user1 = userMapper.selectByEmail(user.getEmail());
        if(user1==null){
            regRespObj.setMsg("可以注册");
        }else {
            regRespObj.setMsg("邮箱重复，请更换邮箱");
        }
        return regRespObj;
    }
    @RequestMapping("logout")
    public String logout(HttpServletRequest request)
    {
        request.getSession().invalidate();
        return "redirect:" + request.getServletContext().getContextPath() +"/";
    }

    @RequestMapping("login")
    public String login(HttpServletRequest request)
    {
        String referer = request.getHeader("Referer");
        HttpSession session = request.getSession();
        session.setAttribute("referer",referer);
            return "user/login";

    }

    @RequestMapping("jumphome/{username}")
    public ModelAndView jumphome(@PathVariable String username,HttpServletRequest request)
    {

        ModelAndView modelAndView = new ModelAndView();
        User user = userMapper.selectByNickname(username);
        modelAndView.addObject("user",user);
        modelAndView.setViewName("user/home");
        return modelAndView;
    }
    @RequestMapping("home/{uid}")
    public ModelAndView home(@PathVariable Integer uid)
    {
        ModelAndView modelAndView = new ModelAndView();
        User user = userMapper.selectByPrimaryKey(uid);
        List<Map<String,Object>> mapList2 = topicMapper.getTopTopicsUseridhuitime(uid);
        System.out.println(mapList2.size());
        for(Map<String,Object> map2 : mapList2)
        {
            Date date2 = (Date)map2.get("comment_time");
            String strDate2 = StringDate.getStringDate(date2);
            map2.put("comment_time",strDate2);
        }
        List<Map<String,Object>> mapList = userMapper.selectByTopicUserId(uid);
        modelAndView.addObject("userList2",mapList2);
        modelAndView.addObject("userList",mapList);
        modelAndView.addObject("user",user);
        modelAndView.setViewName("user/home");
        return modelAndView;
    }
    @RequestMapping("dologin")
    @ResponseBody
    public RegRespObj dologin(User user,HttpServletRequest request)
    {
        HttpSession httpSession = request.getSession();
        String referer = (String)httpSession.getAttribute("referer");
        httpSession.removeAttribute("referer");
        System.out.println("referer++++++++++++"+""+referer);
        //查询数据库，用email和密码作为条件查询，如果查出来0条记录，登录失败
        //否则，登录成功
        user.setPasswd(MD5Utils.getPwd(user.getPasswd()));
        User userResult = userMapper.selectByEmailAndPass(user);
        RegRespObj regRespObj = new RegRespObj();
        if(userResult == null)
        {
            regRespObj.setStatus(1);
            regRespObj.setMsg("登录失败");
        }
        else
        {
            httpSession.setAttribute("userinfo",userResult);
            regRespObj.setStatus(0);
            regRespObj.setAction(referer);
            if (referer==null){
                regRespObj.setAction(request.getServletContext().getContextPath() + "/");
            }else {
                regRespObj.setAction(referer);
            }
        }

        return regRespObj;
    }

    @RequestMapping("set")
    public String userSetting()
    {
        return "user/set";
    }
    @RequestMapping("upload")
    @ResponseBody
    public RegRespObj upload(@RequestParam  MultipartFile file,HttpServletRequest request) throws IOException {
        RegRespObj regRespObj = new RegRespObj();
        if(file.getSize()>0){
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

            userMapper.updateByPrimaryKeySelective(userinfo);

            regRespObj.setStatus(0);
        }
        else
        {
            regRespObj.setStatus(1);
        }
        return regRespObj;
    }
    @RequestMapping("checkNowPass/{id}")
    @ResponseBody
    public RegRespObj checkNowPass(HttpServletRequest request,@PathVariable String id){
        System.out.println("进来没啊啊");
        RegRespObj regRespObj = new RegRespObj();
        HttpSession session = request.getSession();
        User userinfo = (User) session.getAttribute("userinfo");
        String pwd= MD5Utils.getPwd(id);
        if(pwd.equals(userinfo.getPasswd())){
            regRespObj.setMsg("当前密码正确");
        }else {
            regRespObj.setMsg("当前密码错误");
        }
        return regRespObj;
    }
}
