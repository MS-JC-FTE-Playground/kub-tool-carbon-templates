package com.gap.samples.{{ .TemplateBuilder.ApplicationName }};

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class MySpringbootServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(MySpringbootServiceApplication.class, args);
	}

}
