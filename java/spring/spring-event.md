# [spring事件通知机制详解](https://www.cnblogs.com/zhangxiaoguang/p/spring-notification.html)

## 优势

- 解耦
- 对同一种事件有多种处理方式
- 不干扰主线(main line)

## 起源

要讲spring的事件通知机制，就要先了解一下spring中的这些接口和抽象类：

- `ApplicationEventPublisherAware`        接口:用来 publish event
- `ApplicationEvent`                抽象类，记录了source和初始化时间戳：用来定义Event
- `ApplicationListener<E extends ApplicationEvent> ` :用来监听事件

## 构建自己的事件机制案例

### 测试案例

#### 测试入口

```java
package com.meituan.spring.testcase.listener;

import org.springframework.context.support.ClassPathXmlApplicationContext;
import java.util.concurrent.TimeUnit;

/**
 * Created by zhangxiaoguang on 16/1/27 下午11:40.
 * -----------------------------
 * Desc:
 */
public class TestPortal {
   public static void main(String[] args) throws InterruptedException {

      final ClassPathXmlApplicationContext applicationContext = new ClassPathXmlApplicationContext("spring-config.xml");

      String[] definitionNames = applicationContext.getBeanDefinitionNames();
      System.out.println("==============bean====start=================");
      for (String definitionName : definitionNames) {
         System.out.println("bean----:" + definitionName);
      }
      System.out.println("==============bean====end=================");
      System.out.println();
      final CustomizePublisher customizePublisher = applicationContext.getBean(CustomizePublisher.class);


      Thread thread = new Thread(new Runnable() {
         @Override
         public void run() {
            try {
               System.out.println("开始吃饭：");

               MealEvent lunchEvent = new MealEvent("A吃午饭了", MealEnum.lunch);
               MealEvent breakfastEvent = new MealEvent("B吃早饭了", MealEnum.breakfast);
               MealEvent dinnerEvent = new MealEvent("C吃晚饭了", MealEnum.dinner);
               customizePublisher.publish(lunchEvent);
               TimeUnit.SECONDS.sleep(1l);
               customizePublisher.publish(breakfastEvent);
               TimeUnit.SECONDS.sleep(1l);
               customizePublisher.publish(dinnerEvent);
               TimeUnit.SECONDS.sleep(1l);

               System.out.println("他们吃完了！");
            } catch (InterruptedException e) {
               e.printStackTrace();
            }
         }
      });
      thread.setName("meal-thread");
      thread.start();

      System.out.println(Thread.currentThread().getName() + " is waiting for ....");
      thread.join();
      System.out.println("Done!!!!!!!!!!!!");
   }
}
```

#### 测试结果

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171004448-387712576.jpg)

#### 测试成员

- MealListener ：MealEvent                  演员
- TroubleListener ：TroubleEvent         演员
- AllAcceptedListener                              演员
- MealEnum                                              道具
- TestPortal                                               入口
- CustomizePublisher                              导演

#### 成员代码

接受全部事件的演员（很负责任啊） AllAcceptedListener

```java
package com.meituan.spring.testcase.listener;

import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

/**
 * Created by zhangxiaoguang on 16/1/27 下午11:27.
 * -----------------------------
 * Desc:
 */
@Component
public class AllAcceptedListener implements ApplicationListener<ApplicationEvent> {
   @Override
   public void onApplicationEvent(ApplicationEvent event) {
      System.out.println(">>>>>>>>>>>>>>>>event:" + event);
   }
}

```

导演负责分发事件 CustomizePublisher

```java
package com.meituan.spring.testcase.listener;

import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationEventPublisherAware;
import org.springframework.stereotype.Component;

/**
 * Created by zhangxiaoguang on 16/1/28 上午1:41.
 * -----------------------------
 * Desc:
 */
@Component
public class CustomizePublisher implements ApplicationEventPublisherAware {

   private ApplicationEventPublisher applicationEventPublisher;

   public void publish(MealEvent event) {
      applicationEventPublisher.publishEvent(event);
   }

   @Override
   public void setApplicationEventPublisher(ApplicationEventPublisher applicationEventPublisher) {
      this.applicationEventPublisher = applicationEventPublisher;
   }
}
```

负责处理吃饭事件的演员 MealListener

```java
package com.meituan.spring.testcase.listener;

import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

/**
 * Created by zhangxiaoguang on 16/1/27 下午11:27.
 * -----------------------------
 * Desc:
 */
@Component
public class MealListener implements ApplicationListener<MealEvent> {
   @Override
   public void onApplicationEvent(MealEvent event) {
      System.out.println(String.format(">>>>>>>>>>>thread:%s,type:%s,event:%s",
            Thread.currentThread().getName(), event.getMealEnum(), event));

      dispatchEvent(event);
   }

   private void dispatchEvent(MealEvent event) {
      switch (event.getMealEnum()) {
         case breakfast:
            System.out.println(event.getMealEnum() + " to handle!!!");
            break;
         case lunch:
            System.out.println(event.getMealEnum() + " to handle!!!");
            break;
         case dinner:
            System.out.println(event.getMealEnum() + " to handle!!!");
            break;
         default:
            System.out.println(event.getMealEnum() + " error!!!");
            break;
      }
   }
}
```

吃饭消息 MealEvent

```java
package com.meituan.spring.testcase.listener;

import org.springframework.context.ApplicationEvent;

/**
 * Created by zhangxiaoguang on 16/1/27 下午11:24.
 * -----------------------------
 * Desc:吃饭事件
 */
public class MealEvent extends ApplicationEvent {

   private MealEnum mealEnum;

   /**
    * @param mealContent
    *        吃什么
    * @param mealEnum
    *        早餐还是午餐？
    */
   public MealEvent(String mealContent, MealEnum mealEnum) {
      super(mealContent);
      this.mealEnum = mealEnum;
   }

   public MealEnum getMealEnum() {
      return mealEnum;
   }
}

```

工具 MealEnum

```java
package com.meituan.spring.testcase.listener;

/**
 * Created by zhangxiaoguang on 16/1/27 下午11:29.
 * -----------------------------
 * Desc:
 */
public enum MealEnum {
   breakfast,
   lunch,
   dinner
}
```

令人厌烦的演员 TroubleListener

```java
package com.meituan.spring.testcase.listener;

import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

/**
 * Created by zhangxiaoguang on 16/1/27 下午11:27.
 * -----------------------------
 * Desc:
 */
@Component
public class TroubleListener implements ApplicationListener<TroubleEvent> {
   @Override
   public void onApplicationEvent(TroubleEvent event) {
      System.out.println(">>>>>>>>>>>>>>>>event:" + event);
   }
}
```

令人厌烦的事件 TroubleEvent

```java
package com.meituan.spring.testcase.listener;

import org.springframework.context.ApplicationEvent;

/**
 * Created by zhangxiaoguang on 16/1/27 下午11:24.
 * -----------------------------
 * Desc:令人厌烦的事件
 */
public class TroubleEvent extends ApplicationEvent {
   public TroubleEvent(Object source) {
      super(source);
   }
}
```

总结

详细定制 event 类型的，则相关定制的listener会处理对应的消息，其他listener不会管闲事；

制定顶级 event 类型的，ApplicationEvent的，则会处理所有的事件。

## ApplicationEvent

### 依赖关系

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171030713-773946919.jpg)

## ContextEvent事件机制简介

ContextRefreshedEvent:当整个ApplicationContext容器初始化完毕或者刷新时触发该事件；

```java
@Override
public void refresh() throws BeansException, IllegalStateException {
   synchronized (this.startupShutdownMonitor) {
      ......

      try {
         
         ......

         // Last step: publish corresponding event.
         finishRefresh();
      }

      catch (BeansException ex) {
         ......
      }
   }
}
protected void finishRefresh() {
   // Initialize lifecycle processor for this context.
   initLifecycleProcessor();

   // Propagate refresh to lifecycle processor first.
   getLifecycleProcessor().onRefresh();

   // Publish the final event.
   publishEvent(new ContextRefreshedEvent(this));

   // Participate in LiveBeansView MBean, if active.
   LiveBeansView.registerApplicationContext(this);
}
```

ContextClosedEvent:当ApplicationContext doClose时触发该事件,这个时候会销毁所有的单例bean； 

```java
@Override
public void registerShutdownHook() {
   if (this.shutdownHook == null) {
      // No shutdown hook registered yet.
      this.shutdownHook = new Thread() {
         @Override
         public void run() {
            doClose();
         }
      };
      Runtime.getRuntime().addShutdownHook(this.shutdownHook);
   }
}
@Override
public void close() {
   synchronized (this.startupShutdownMonitor) {
      doClose();
      // If we registered a JVM shutdown hook, we don't need it anymore now:
      // We've already explicitly closed the context.
      if (this.shutdownHook != null) {
         try {
            Runtime.getRuntime().removeShutdownHook(this.shutdownHook);
         }
         catch (IllegalStateException ex) {
            // ignore - VM is already shutting down
         }
      }
   }
}
protected void doClose() {
   if (this.active.get() && this.closed.compareAndSet(false, true)) {
      ......
 
      try {
         // Publish shutdown event.
         publishEvent(new ContextClosedEvent(this));
      }
      catch (Throwable ex) {
         logger.warn("Exception thrown from ApplicationListener handling ContextClosedEvent", ex);
      }
 
      ......
   }
}
```
ContextStartedEvent:当ApplicationContext start时触发该事件； 

```java
@Override
public void start() {
    getLifecycleProcessor().start();
    publishEvent(new ContextStartedEvent(this));
}
```

ContextStoppedEvent:当ApplicationContext stop时触发该事件； 

```java
 @Override
 public void stop() {
    getLifecycleProcessor().stop();
    publishEvent(new ContextStoppedEvent(this));
 }
```

## ApplicationListener 

### 依赖关系

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171046207-842479262.jpg)

## 带你一步步走向源码的世界

从上边打印的线程信息可以知道，spring处理事件通知采用的是当前线程，并没有为为我们启动新的线程，所以，如果需要，你要自己处理线程信息哦，当然也可以设定（如何设置？）！

AbstractApplicationContext

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171607426-1609475164.jpg)

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171626098-729428804.jpg)

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171640051-1352302358.jpg)

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171652457-645473014.jpg)

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171703535-1072539193.jpg)

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171716192-379933284.jpg)

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171727785-1223109541.jpg)

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171739426-1597130972.jpg)

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171750598-1730915724.jpg)

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171800457-286921548.jpg)

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171811864-465710472.jpg)

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171822770-451980567.jpg)

补齐：同一个event，被多个listener监听，先被哪个listener执行是由下边的代码决定的：

![img](https://images2015.cnblogs.com/blog/893686/201602/893686-20160222171833114-541677363.jpg)

## 如何设置线程池？

回到上边的问题，到底该如何设置线程池呢？

AbstractApplicationEventMulticaster 是private的，并且没有提供写入方法...