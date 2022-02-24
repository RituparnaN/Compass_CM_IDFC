package com.quantumdataengines.app.compass.util;

import java.io.IOException;
import java.lang.invoke.MethodHandles;

import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Component;

@Component
public class StartupApplicationListenerExample implements ApplicationListener<ContextRefreshedEvent> {
 
    @Override 
    public void onApplicationEvent(ContextRefreshedEvent event) {
    	ClassLoader classLoader = MethodHandles.lookup().getClass().getClassLoader();
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver(classLoader);

        try {
			Resource[] resoureArray = resolver.getResources("classpath:language/*.properties");
			
			for(Resource resource : resoureArray) {
				System.out.println(resource.getFilename());
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
    }
}
