using SbsSW.SwiPlCs;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace GUI_Prolog
{
    public partial class Form1 : Form
    {
        //Globals
        int tamannoMatriz = 0;
        int cambiosMatriz = 0;

        public Form1()
        {
            InitializeComponent();
            checkBox1.Visible = false;
            button4.Enabled = false;
            linkLabel1.Visible = false;
            linkLabel2.Visible = false;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Environment.SetEnvironmentVariable("Path", @"C:\\Program Files (x86)\\swipl\\bin");
            string[] p = { "-q", "-f", @"codigo.pl" };
            PlEngine.Initialize(p);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            checkBox1.Checked = false;
            if (Int32.TryParse(textBox1.Text, out tamannoMatriz))
            {
                crearMatriz(tamannoMatriz, 1);
                checkBox1.Visible = true;
                linkLabel1.Visible = true;
            }
            else
            {
                MessageBox.Show("Debe digitar un número entero para el tamaño de la matriz",
                    "Advertencia" ,MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            textBox1.Text = string.Empty;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            dataGridView1.Enabled = true;
            if (Int32.TryParse(textBox1.Text, out tamannoMatriz))
            {
                checkBox1.Visible = false;
                crearMatriz(tamannoMatriz, 2);
                button4.Enabled = true;
                linkLabel2.Visible = true;
            }
            else
            {
                MessageBox.Show("Debe digitar un número entero para el tamaño de la matriz",
                    "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            textBox1.Text = string.Empty;
        }

        void crearMatriz(int tamannoMatriz, int tipoGenerar)
        {
            dataGridView1.Rows.Clear();
            dataGridView1.Columns.Clear();
            dataGridView1.RowsDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            dataGridView1.ColumnCount = tamannoMatriz;
            for (int i = 1; i < tamannoMatriz; i++)
            {
                dataGridView1.Rows.Add();
            }
            dataGridView1.ColumnHeadersVisible = false;
            dataGridView1.RowHeadersVisible = false;
            dataGridView1.AllowUserToResizeRows = false;
            dataGridView1.AllowUserToResizeColumns = false;
            foreach (DataGridViewBand band in dataGridView1.Columns)
            {
                band.ReadOnly = true;
            }
            if (tipoGenerar == 1)
            {
                cambiosMatriz = 0;
                MessageBox.Show("Proceda a llenar la matriz" +
                    "\nClick en ver consejo para más información","Matriz generada con éxito", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            else
            {
                MessageBox.Show("Generando matriz automatica");
                llenarAutomatico(tamannoMatriz);
                cambiosMatriz = 1;
                dataGridView1.ClearSelection();
                button4.Enabled = true;
            }
        

            //dataGridView1[1, 1].Value = "hola";
        }

        void llenarAutomatico(int tamannoMatriz) {
            Random r = new Random();
            int val = r.Next(0, (tamannoMatriz * tamannoMatriz));
            for (int i = 0; i <= val; i++)
            {
                int p1 = r.Next(0, tamannoMatriz);
                int p2 = r.Next(0, tamannoMatriz);
                if ((string)dataGridView1.Rows[p1].Cells[p2].Value == "X")
                {
                    dataGridView1.Rows[p1].Cells[p2].Value = "X";
                }
                else
                {
                    dataGridView1.Rows[p1].Cells[p2].Value = "X";
                    
                }
            }
        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
        
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBox1.Checked)
            {
                dataGridView1.ClearSelection();
                cambiosMatriz = 1;
                button4.Enabled = true;
            }
            else
            {
                dataGridView1.Enabled = true;
                button4.Enabled = false;
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            textBox1.Enabled = false;
            button2.Enabled = false;
            button3.Enabled = false;
            recorrerDataGrid();
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            MessageBox.Show("1) Seleccione con el click izquierdo la casilla que desea llenar" +
            "\n2) Use el click derecho sobre una casilla para borrar su contenido" +
            "\n3) Al finalizar seleccione el comboBox en la parte inferior de la " +
            "matriz para cargar los datos de la matriz" +
            "\n4) Si ya pulsó el botón Cargar Datos, para reiniciar presione Limpiar Data "
            ,"Consejo");
        }

        private void dataGridView1_MouseDown(object sender, MouseEventArgs e)
        {
            try
            {
                if (cambiosMatriz == 0)
                {
                    if (e.Button == MouseButtons.Right)
                    {
                        var hit = dataGridView1.HitTest(e.X, e.Y);
                        dataGridView1.ClearSelection();
                        dataGridView1[hit.ColumnIndex, hit.RowIndex].Value = "";
                    }
                    if (e.Button == MouseButtons.Left)
                    {
                        var hit = dataGridView1.HitTest(e.X, e.Y);
                        dataGridView1.ClearSelection();
                        dataGridView1[hit.ColumnIndex, hit.RowIndex].Value = "X";
                    }
                }
            }
            catch (ArgumentOutOfRangeException outOfRange)
            {
                MessageBox.Show("De click dentro de la matriz", "Fuera de rango", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        void recorrerDataGrid() {
            bool tiene = false;
            for (int i = 0; i < tamannoMatriz; i++)
            {
                for (int j = 0; j < tamannoMatriz; j++)
                {
                    if ((string)dataGridView1.Rows[i].Cells[j].Value == "X")
                    {
                        tiene = true;
                        string codData = "pares(" + i + "," + j + ")";
                        llenarDataProlog(codData);
                    }
                }
            }
            if (tiene)
            {
                imprimirData();
            }
            else
            {
                MessageBox.Show("Matriz Vacía", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }

        }

        void llenarDataProlog(string codData) {

            PlQuery.PlCall("assert(" + codData + ")");

        }

        void imprimirData() {
            using (var q1 = new PlQuery("pares(X, Y), atomic_list_concat([X,',',Y], L)"))
            {
                foreach (PlQueryVariables x in q1.SolutionVariables)
                    listBox1.Items.Add(x["L"].ToString());
            }

        }

        void imprimirGrupos() { 
            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            PlEngine.PlCleanup();
            Environment.SetEnvironmentVariable("Path", @"C:\\Program Files (x86)\\swipl\\bin");
            string[] p = { "-q", "-f", @"codigo.pl" };
            PlEngine.Initialize(p);
            dataGridView1.Rows.Clear();
            dataGridView1.Columns.Clear();
            checkBox1.Checked = false;
            checkBox1.Visible = false;
            button4.Enabled = false;
            linkLabel1.Visible = false;
            linkLabel2.Visible = false;
            listBox1.Items.Clear();
            textBox1.Enabled = true;
            button2.Enabled = true;
            button3.Enabled = true;
        }

        private void linkLabel2_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            MessageBox.Show("1) Si ya pulsó el botón Cargar Datos, para reiniciar" +
                " presione Limpiar Data ", "Consejo");

        }
    }
}
