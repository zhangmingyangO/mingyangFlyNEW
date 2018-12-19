package com.neusoft.controller;

import com.neusoft.mapper.CommentMapper;
import com.neusoft.mapper.TopicMapper;
import com.neusoft.util.StringDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2018/12/6.
 */
@Controller
public class IndexController {

    @Autowired
    TopicMapper topicMapper;
    @Autowired
    CommentMapper commentMapper;

    @RequestMapping("/")
    public ModelAndView index()
    {
        List<Map<String,Object>> mapList = topicMapper.getTopTopics();
        List<Map<String,Object>> mapList1 = commentMapper.getCommentsByTopicCountID();
        List<Map<String,Object>> mapList2 = topicMapper.getTopicsCommentHot();
        for(Map<String,Object> map : mapList)
        {
            Date date = (Date)map.get("create_time");
            String strDate = StringDate.getStringDate(date);
            map.put("create_time",strDate);
        }
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("index");
        modelAndView.addObject("top_topics",mapList);
        modelAndView.addObject("top_comment",mapList1);
        modelAndView.addObject("hot_Comment",mapList2);
        modelAndView.addObject("typeid",0);
        return modelAndView;
//        List<Map<String,Object>> mapList = topicMapper.getAllTopics();
//        for(Map<String,Object> map : mapList)
//        {
//            Date date = (Date)map.get("create_time");
//            String strDate = StringDate.getStringDate(date);
//            map.put("create_time",strDate);
//        }
//        modelAndView.setViewName("page");
//        for(Map<String,Object> map : mapList)
//        {
//            Date date = (Date)map.get("create_time");
//            String strDate = StringDate.getStringDate(date);
//            map.put("create_time",strDate);
//        }
//        modelAndView.setViewName("index");

    }
}


