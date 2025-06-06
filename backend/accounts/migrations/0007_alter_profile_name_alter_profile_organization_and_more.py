# Generated by Django 5.0.1 on 2025-04-18 08:58

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0006_profile_cover'),
    ]

    operations = [
        migrations.AlterField(
            model_name='profile',
            name='name',
            field=models.CharField(blank=True, max_length=50, null=True, verbose_name='Name'),
        ),
        migrations.AlterField(
            model_name='profile',
            name='organization',
            field=models.CharField(blank=True, max_length=50, null=True, verbose_name='Organization'),
        ),
        migrations.AlterField(
            model_name='profile',
            name='rank',
            field=models.CharField(default='Bornze', max_length=50, verbose_name='Rank'),
        ),
        migrations.AlterField(
            model_name='profile',
            name='tagline',
            field=models.CharField(blank=True, max_length=50, null=True, verbose_name='Tagline'),
        ),
    ]
