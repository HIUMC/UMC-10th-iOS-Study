package com.example.httptest.httpmethodtest.DTO;

public class Person {
    private String name;
    private Integer age;
    private String address;
    private Double height;

    public Person() {}

    public Person(String name, Integer age, String address, Double height) {
        this.name = name;
        this.age = age;
        this.address = address;
        this.height = height;
    }

    // Getter, Setter 설정

    public String getName() {
        return name;
    }

    public  void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Double getHeight() {
        return height;
    }

    public void setHeight(Double height) {
        this.height = height;
    }

}