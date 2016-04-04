---
layout:   post
title:    "Accessing Stored Procedures with JPA 2.0 and Hibernate"
category: dev
tags:     hibernate java
comments: true
---

[JPA 2.0](http://download.oracle.com/otndocs/jcp/persistence-2.0-fr-oth-JSpec/) has no explicit support for stored procedures (JPA 2.1 has). One workaround is to use native queries (like `{call my_package.my_stored_proc(?, ?)}`), but that doesn't work when the procedure has out-parameters.
Here is a sample implementation that uses Hibernate's [Work](https://docs.jboss.org/hibernate/orm/4.0/javadocs/org/hibernate/jdbc/Work.html) interface:

```java
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceUnit;
import org.hibernate.Session;
import org.hibernate.jdbc.Work;

public class StoredProcedureDemo {

  @PersistenceUnit(name = "jpa-test")
  private EntityManager entityManager;

  private Integer callStoredProcedure(String param1, int param2) {
    MyStoredProc storedProc = new MyStoredProc(param1, param2);
    entityManager.unwrap(Session.class).doWork(storedProc);
    return storedProc.getOutParam();
  }

  private static final class MyStoredProc implements Work {

    private final String inParam1;
    private final int inParam2;
    private Integer outParam;

    private MyStoredProc(String inParam1, int inParam2) {
      this.inParam1 = inParam1;
      this.inParam2 = inParam2;
    }

    @Override
    public void execute(Connection conn) throws SQLException {
      try (CallableStatement stmt = conn.prepareCall(
        "{CALL my_package.my_stored_proc(:inParam1, :inParam2, :outParam)}")) {
        stmt.setString("inParam1", inParam1);
        stmt.setInt("inParam2", inParam2);
        stmt.registerOutParameter("outParam", Types.INTEGER);
        stmt.executeUpdate();
        outParam = stmt.getInt("outParam");
        if (stmt.wasNull()) {
          outParam = null;
        }
      }
    }

    public Integer getOutParam() {
      return outParam;
    }
  }
}
```
