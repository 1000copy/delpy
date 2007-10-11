using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Collections;
public partial class _Default : System.Web.UI.Page
{

    //清清月儿http://blog.csdn.net/21aspnet 
    // 1000copy http://1000copy.spaces.live.com 改编 2007-10-11
    ArrayList personarray = null;
    public _Default()
    {
        //if (Session["PersonArray"] == null)
        //{

            personarray = new ArrayList();
            Hero person = new Hero();
            person.Id = "11";
            person.Name = "宋江";
            person.Level = "1";
            personarray.Add(person);
            person = new Hero();
            person.Id = "12";
            person.Level = "2";
            person.Name = "李逵";
            personarray.Add(person);
            person = new Hero();
            person.Id = "13";
            person.Level = "2";
            person.Name = "花荣";
            personarray.Add(person);
            person = new Hero();
            person.Id = "14";
            person.Level = "2";
            person.Name = "武松";
            personarray.Add(person);
            //Session["PersonArray"] = personarray;
        //}
    }
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
          
            bind();
        }
    }
    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView1.EditIndex = e.NewEditIndex;
        bind();
    }

    //删除
    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string currentkey = GridView1.DataKeys[e.RowIndex].Value.ToString();
        //personarray = (ArrayList)Session["PersonArray"];
        foreach (Hero person in personarray)
        {
            if (currentkey == person.Id)
            {
                personarray.Remove(person);
                break;
            }
        } 
        bind();
    }

    //更新
    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        string newname = ((TextBox)(GridView1.Rows[e.RowIndex].Cells[1].Controls[0])).Text.ToString().Trim();
        string newlevel = ((DropDownList)(GridView1.Rows[e.RowIndex].Cells[2].FindControl("DropDownList1"))).SelectedValue.ToString().Trim();
        string currentkey = GridView1.DataKeys[e.RowIndex].Value.ToString();
        //personarray = (ArrayList)Session["PersonArray"];
        foreach (Hero person in personarray)
        {
            if (currentkey == person.Id)
            {
                person.Name = newname;
                person.Level = newlevel;
            }
        }
        GridView1.EditIndex = -1;
        bind();
    }

    //取消
    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView1.EditIndex = -1;
        bind();
    }

    //绑定
    public void bind()
    {
      //  personarray = (ArrayList)Session["PersonArray"];
      GridView1.DataSource = personarray;
      GridView1.DataKeyNames = new string[] { "id" };//主键
      GridView1.DataBind();
      for (int i = 0; i <= GridView1.Rows.Count - 1; i++)
      {          
          DropDownList ddl = (DropDownList)GridView1.Rows[i].FindControl("DropDownList1");
          if (ddl != null)
          {
              if ("13" == GridView1.DataKeys[i].Value.ToString())
              {
                  ddl.SelectedValue = "1";
              }
              else
              {
                  ddl.SelectedValue = "2";
              }
          }
      }

    }
    public ArrayList LevelList()
    {
        ArrayList al = new ArrayList();
        HeroLevel a = new HeroLevel();
        a.Name = "天罡星";
        a.Id ="1";        
        al.Add(a);
        a = new HeroLevel();
        a.Name = "地煞星";
        a.Id = "2";
        al.Add(a);
        return al;
    }

}
public class Hero
{
    private string _name = "";
    private string _id = "";
    private string _level = "";

    public string Level
    {
        get { return _level; }
        set { _level = value; }
    }
    public string Id
    {
        get { return _id; }
        set { _id = value; }
    }
    public string Name
    {
        get { return _name; }
        set { _name = value; }
    }
}
public class HeroLevel
{
    private string _name = "";
    private string _id = "";
    public string Id
    {
        get { return _id; }
        set { _id = value; }
    }
    public string Name
    {
        get { return _name; }
        set { _name = value; }
    }
}
