//import java.sql.DriverManager;
//import java.util.*;
import java.sql.*;

public class JdbcDemo {

public static void main(String arg[]) throws Exception

{
	//load the driver
	Class.forName("oracle.jdbc.driver.OracleDriver");
	
	//get the connection object
	//Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@fourier.cs.iit.edu:1521:orcl","yhong", "your_pwd");
	Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl12c","system", "oracle");
	
	
	//create the statement object
	Statement st=conn.createStatement();
	
	//execute query
	String dept = "Music";
	
	ResultSet rs=st.executeQuery("select * from Instructor where dept_name='"+dept+"'");
	
//	Statement st2=conn.createStatement();
//	st2.executeUpdate("insert into instructor values('11237', 'Kim', 'Physics', 98000)");
	
	while(rs.next()) {
		System.out.println(rs.getString(1)+ "  "+ rs.getString("Name")+ "  "+ rs.getString("dept_name")+ "  "+ rs.getFloat(4));
	}
	
	//prepared statement
	
	PreparedStatement pStmt = conn.prepareStatement("insert into instructor values(?,?,?,?)");
	pStmt.setString(1,"88871");
	pStmt.setString(2,"Perry");
	pStmt.setString(3,"Finance");
	pStmt.setInt(4, 125000);
	pStmt.executeUpdate();
	//another example
	pStmt.setString(1,"88872");
	pStmt.executeUpdate();
	
	//result set metadata
	
	ResultSetMetaData rsmd = rs.getMetaData();
	
	System.out.println("\nThis gives us the metadata for the resultset\n");
	
	for(int i=1; i<=rsmd.getColumnCount();i++) {
		System.out.println(rsmd.getColumnName(i));
		System.out.println(rsmd.getColumnTypeName(i));
	}
	
	//database metadata
	
	DatabaseMetaData dbmd= conn.getMetaData();
	//ResultSet rs2 = dbmd.getColumns(catalog, schemaPattern, tableNamePattern, columnNamePattern)
	ResultSet rs2 = dbmd.getColumns(null, "%", "INSTRUCTOR", "%");
	
	System.out.println("\nThis gives us the metadata for the database\n");
	
	while(rs2.next()) {
	       System.out.println(rs2.getString("COLUMN_NAME") + "  "+ rs2.getString("TYPE_NAME") + "  "+ rs2.getString("COLUMN_SIZE")); 
  }
	/*
	*/
	
	//con.commit();
	//con.rollback();
	//con.setAutoCommit(true);
	
	//close the connection object
	st.close();
	conn.close();
}
	
	
}
