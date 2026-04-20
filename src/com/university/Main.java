package com.university;

import java.sql.*;
import java.util.Scanner;

public class Main {
    // 'db' is the service name defined in docker-compose.yml
    private static final String URL = "jdbc:postgresql://db:5432/university_db";
    private static final String USER = "postgres";
    private static final String PASS = "docker_pass";

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.println("Connecting to Database...");
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS)) {
            System.out.println("Connected successfully!");

            while (true) {
                System.out.println("\n--- Student Management CLI ---");
                System.out.println("1. Login as Professor (Manage Data)");
                System.out.println("2. Login as Student (View Courses)");
                System.out.println("3. Exit");
                System.out.print("Choice: ");
                
                int choice = scanner.nextInt();
                if (choice == 1) professorPortal(conn, scanner);
                else if (choice == 2) studentPortal(conn);
                else break;
            }
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
        }
    }

    private static void professorPortal(Connection conn, Scanner sc) throws SQLException {
        System.out.println("\n[Professor Portal]");
        System.out.println("1. Add New Course\n2. View All Students");
        int op = sc.nextInt();
        sc.nextLine(); // consume newline

        if (op == 1) {
            System.out.print("Enter Course Name: ");
            String name = sc.nextLine();
            System.out.print("Enter Professor Name: ");
            String prof = sc.nextLine();
            
            String query = "INSERT INTO courses (name, professor) VALUES (?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setString(1, name);
                pstmt.setString(2, prof);
                pstmt.executeUpdate();
                System.out.println("Database updated successfully.");
            }
        } else {
            ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM students");
            while (rs.next()) {
                System.out.printf("Student: %s | Email: %s\n", rs.getString("name"), rs.getString("email"));
            }
        }
    }

    private static void studentPortal(Connection conn) throws SQLException {
        System.out.println("\n[Student Portal - Available Courses]");
        String query = "SELECT * FROM courses";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
            System.out.println("ID | Course Name | Professor");
            while (rs.next()) {
                System.out.printf("%d | %s | %s\n", rs.getInt("id"), rs.getString("name"), rs.getString("professor"));
            }
        }
    }
}