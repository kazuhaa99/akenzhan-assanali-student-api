package kz.akenzhan.studentapi;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import kz.akenzhan.studentapi.student.Student;
import kz.akenzhan.studentapi.student.StudentRepository;

@SpringBootTest
@AutoConfigureMockMvc
class StudentControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private StudentRepository repository;

    @BeforeEach
    void cleanDatabase() {
        repository.deleteAll();
    }

    @Test
    void createsStudent() throws Exception {
        mockMvc.perform(post("/api/students")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"firstName":"Assanali","lastName":"Akenzhan",
                                 "email":"assanali.akenzhan@iitu.edu.kz","course":"DevOps"}
                                """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.lastName").value("Akenzhan"));
    }

    @Test
    void returnsStudentById() throws Exception {
        Student saved = repository.save(new Student("Assanali", "Akenzhan", "a.akenzhan@iitu.edu.kz", "DevOps"));

        mockMvc.perform(get("/api/students/{id}", saved.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.firstName").value("Assanali"));
    }

    @Test
    void returnsNotFoundForMissingStudent() throws Exception {
        mockMvc.perform(get("/api/students/{id}", 999))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.message").value("Student with id 999 not found"));
    }

    @Test
    void updatesStudent() throws Exception {
        Student saved = repository.save(new Student("Assanali", "Akenzhan", "old.mail@iitu.edu.kz", "DevOps"));

        mockMvc.perform(put("/api/students/{id}", saved.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"firstName":"Assanali","lastName":"Akenzhan",
                                 "email":"new.mail@iitu.edu.kz","course":"DevOps Mastery"}
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.email").value("new.mail@iitu.edu.kz"))
                .andExpect(jsonPath("$.course").value("DevOps Mastery"));
    }

    @Test
    void updateReturnsNotFoundForMissingStudent() throws Exception {
        mockMvc.perform(put("/api/students/{id}", 999)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"firstName":"X","lastName":"Y","email":"x.y@iitu.edu.kz"}
                                """))
                .andExpect(status().isNotFound());
    }

    @Test
    void deletesStudent() throws Exception {
        Student saved = repository.save(new Student("Assanali", "Akenzhan", "delete.me@iitu.edu.kz", "DevOps"));

        mockMvc.perform(delete("/api/students/{id}", saved.getId()))
                .andExpect(status().isNoContent());
    }

    @Test
    void showsStudentNameOnRootPage() throws Exception {
        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.student").value("Akenzhan Assanali"));
    }
}
